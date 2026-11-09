import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String apiBaseUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'http://10.0.2.2:8080/api',
);

class ApiClient {
  String? token;
  final prefs = SharedPreferences.getInstance();

  Future<void> loadToken() async {
    final p = await prefs;
    token = p.getString('token');
  }

  Future<void> saveAuth(Map<String,dynamic> data) async {
    final p = await prefs;
    token = data['token'];
    await p.setString('token', data['token']);
    await p.setString('name', data['fullName'] ?? '');
    await p.setString('email', data['email'] ?? '');
    await p.setString('role', data['role'] ?? '');
  }

  Future<void> logout() async {
    final p = await prefs;
    await p.clear();
    token = null;
  }

  Map<String,String> headers({bool auth=true}) => {
    'Content-Type':'application/json',
    if(auth && token != null) 'Authorization':'Bearer $token',
  };

  Future<Map<String,dynamic>> login(String email,String password) async {
    final r=await http.post(Uri.parse('$apiBaseUrl/auth/login'),
      headers:headers(auth:false),
      body:jsonEncode({'email':email,'password':password}));
    return _json(r);
  }

  Future<Map<String,dynamic>> register(String name,String email,String password,String role) async {
    final r=await http.post(Uri.parse('$apiBaseUrl/auth/register'),
      headers:headers(auth:false),
      body:jsonEncode({'fullName':name,'email':email,'password':password,'role':role}));
    return _json(r);
  }

  Future<List<dynamic>> available(DateTime date, TimeOfDay time) async {
    final d='${date.year.toString().padLeft(4,'0')}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}';
    final t='${time.hour.toString().padLeft(2,'0')}:${time.minute.toString().padLeft(2,'0')}:00';
    final r=await http.get(Uri.parse('$apiBaseUrl/spaces/available?date=$d&time=$t'),headers:headers());
    return _list(r);
  }

  Future<List<dynamic>> spaces() async {
    final r=await http.get(Uri.parse('$apiBaseUrl/spaces'),headers:headers());
    return _list(r);
  }

  Future<List<dynamic>> reservations() async {
    final r=await http.get(Uri.parse('$apiBaseUrl/reservations/mine'),headers:headers());
    return _list(r);
  }

  Future<Map<String,dynamic>> reserve(int spaceId,DateTime date,TimeOfDay time) async {
    final d='${date.year.toString().padLeft(4,'0')}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}';
    final t='${time.hour.toString().padLeft(2,'0')}:${time.minute.toString().padLeft(2,'0')}:00';
    final r=await http.post(Uri.parse('$apiBaseUrl/reservations'),
      headers:headers(),body:jsonEncode({'spaceId':spaceId,'date':d,'time':t}));
    return _json(r);
  }

  Future<void> cancel(int id) async {
    final r=await http.delete(Uri.parse('$apiBaseUrl/reservations/$id'),headers:headers());
    if(r.statusCode<200 || r.statusCode>=300) throw Exception(_message(r));
  }

  Map<String,dynamic> _json(http.Response r) {
    dynamic body;
    try { body=jsonDecode(r.body); } catch (_) { body={}; }
    if(r.statusCode<200 || r.statusCode>=300) {
      throw Exception(body is Map && body['message']!=null ? body['message'] : 'Error ${r.statusCode}');
    }
    return Map<String,dynamic>.from(body);
  }
  List<dynamic> _list(http.Response r) {
    if(r.statusCode<200 || r.statusCode>=300) throw Exception(_message(r));
    return jsonDecode(r.body) as List<dynamic>;
  }
  String _message(http.Response r) {
    try { final x=jsonDecode(r.body); return x['message'] ?? 'Error ${r.statusCode}'; }
    catch(_){return 'Error ${r.statusCode}';}
  }
}

final api=ApiClient();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await api.loadToken();
  runApp(const UniReserveApp());
}

class UniReserveApp extends StatelessWidget {
  const UniReserveApp({super.key});
  @override Widget build(BuildContext context)=>MaterialApp(
    debugShowCheckedModeBanner:false,title:'UniReserve',
    theme:ThemeData(useMaterial3:true,colorSchemeSeed:Colors.indigo),
    home: api.token==null ? const LoginPage() : const HomePage(),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override State<LoginPage> createState()=>_LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final email=TextEditingController(text:'estudiante@unireserve.com');
  final password=TextEditingController(text:'123456');
  bool register=false,loading=false,obscure=true;
  final name=TextEditingController();
  String role='STUDENT';

  Future<void> submit() async {
    setState(()=>loading=true);
    try {
      final data=register
        ? await api.register(name.text.trim(),email.text.trim(),password.text,role)
        : await api.login(email.text.trim(),password.text);
      await api.saveAuth(data);
      if(mounted) Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const HomePage()));
    } catch(e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e.toString().replaceFirst('Exception: ',''))));
    } finally { if(mounted)setState(()=>loading=false); }
  }

  @override Widget build(BuildContext context)=>Scaffold(
    body: SafeArea(child: Center(child: SingleChildScrollView(
      padding:const EdgeInsets.all(24),
      child: ConstrainedBox(constraints:const BoxConstraints(maxWidth:480),child:Column(
        crossAxisAlignment:CrossAxisAlignment.stretch,children:[
          const Icon(Icons.school,size:72),const SizedBox(height:12),
          Text('UniReserve',textAlign:TextAlign.center,style:Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight:FontWeight.bold)),
          const Text('Reserva de espacios académicos',textAlign:TextAlign.center),
          const SizedBox(height:32),
          if(register)...[
            TextField(controller:name,decoration:const InputDecoration(labelText:'Nombre completo',prefixIcon:Icon(Icons.person))),
            const SizedBox(height:12),
            DropdownButtonFormField<String>(value:role,decoration:const InputDecoration(labelText:'Tipo de usuario'),items:const[
              DropdownMenuItem(value:'STUDENT',child:Text('Estudiante')),
              DropdownMenuItem(value:'TEACHER',child:Text('Docente')),
            ],onChanged:(v)=>setState(()=>role=v!)),
            const SizedBox(height:12),
          ],
          TextField(controller:email,keyboardType:TextInputType.emailAddress,decoration:const InputDecoration(labelText:'Correo',prefixIcon:Icon(Icons.email))),
          const SizedBox(height:12),
          TextField(controller:password,obscureText:obscure,decoration:InputDecoration(labelText:'Contraseña',prefixIcon:const Icon(Icons.lock),suffixIcon:IconButton(icon:Icon(Icons.visibility),onPressed:()=>setState(()=>obscure=!obscure)))),
          const SizedBox(height:20),
          FilledButton(onPressed:loading?null:submit,child:loading?const CircularProgressIndicator():Text(register?'Crear cuenta':'Iniciar sesión')),
          const SizedBox(height:8),
          TextButton(onPressed:()=>setState(()=>register=!register),child:Text(register?'Ya tengo una cuenta':'Crear una cuenta')),
          if(!register) const Padding(padding:EdgeInsets.only(top:12),child:Text('Demo: estudiante@unireserve.com / 123456',textAlign:TextAlign.center)),
        ],
      )),
    )))
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState()=>_HomePageState();
}
class _HomePageState extends State<HomePage> {
  int index=0;
  DateTime date=DateTime.now();
  TimeOfDay time=const TimeOfDay(hour:8,minute:0);
  List<dynamic> available=[], mine=[], allSpaces=[];
  bool loading=false;

  @override void initState(){super.initState();loadAvailable();}

  Future<void> loadAvailable() async {
    setState(()=>loading=true);
    try { available=await api.available(date,time); }
    catch(e){showError(e);}
    finally{if(mounted)setState(()=>loading=false);}
  }
  Future<void> loadMine() async {
    try { mine=await api.reservations(); setState((){}); } catch(e){showError(e);}
  }
  Future<void> loadSpaces() async {
    try { allSpaces=await api.spaces(); setState((){}); } catch(e){showError(e);}
  }
  void showError(Object e)=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e.toString().replaceFirst('Exception: ',''))));

  String dateText(DateTime d)=>'${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}';
  String timeText(TimeOfDay t)=>'${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}';

  Future<void> chooseDate() async {
    final d=await showDatePicker(context:context,initialDate:date,firstDate:DateTime.now(),lastDate:DateTime.now().add(const Duration(days:365)));
    if(d!=null){setState(()=>date=d);await loadAvailable();}
  }
  Future<void> chooseTime() async {
    final t=await showTimePicker(context:context,initialTime:time);
    if(t!=null){setState(()=>time=t);await loadAvailable();}
  }
  Future<void> reserve(dynamic s) async {
    try {
      await api.reserve(s['id'],date,time);
      if(mounted) await showDialog(context:context,builder:(_)=>AlertDialog(
        icon:const Icon(Icons.check_circle,size:50),
        title:const Text('Reserva confirmada'),
        content:Text('${s['name']}\\n${dateText(date)} a las ${timeText(time)}'),
        actions:[FilledButton(onPressed:()=>Navigator.pop(context),child:const Text('Aceptar'))],
      ));
      await loadAvailable();
    } catch(e){showError(e);}
  }
  Future<void> cancel(dynamic r) async {
    final ok=await showDialog<bool>(context:context,builder:(_)=>AlertDialog(
      title:const Text('Cancelar reserva'),
      content:Text('¿Cancelar ${r['space']['name']}?'),
      actions:[TextButton(onPressed:()=>Navigator.pop(context,false),child:const Text('No')),
        FilledButton(onPressed:()=>Navigator.pop(context,true),child:const Text('Sí, cancelar'))]));
    if(ok==true) {
      try {await api.cancel(r['id']);await loadMine();}catch(e){showError(e);}
    }
  }

  Widget home()=>RefreshIndicator(onRefresh:loadAvailable,child:ListView(padding:const EdgeInsets.all(16),children:[
    Text('Hola, ${'usuario'} 👋',style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.bold)),
    const SizedBox(height:6),const Text('Encuentra y reserva un espacio académico.'),
    const SizedBox(height:20),
    Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text('Consultar disponibilidad',style:Theme.of(context).textTheme.titleLarge),
      const SizedBox(height:14),
      ListTile(leading:const Icon(Icons.calendar_month),title:const Text('Fecha'),subtitle:Text(dateText(date)),onTap:chooseDate),
      ListTile(leading:const Icon(Icons.schedule),title:const Text('Horario'),subtitle:Text(timeText(time)),onTap:chooseTime),
    ]))),
    const SizedBox(height:18),
    Row(children:[Text('Espacios disponibles',style:Theme.of(context).textTheme.titleLarge),const Spacer(),Text('${available.length}')]),
    const SizedBox(height:8),
    if(loading)const Center(child:Padding(padding:EdgeInsets.all(30),child:CircularProgressIndicator()))
    else if(available.isEmpty)const Card(child:Padding(padding:EdgeInsets.all(24),child:Text('No hay espacios disponibles para ese horario.',textAlign:TextAlign.center)))
    else ...available.map(spaceCard),
  ]));

  Widget spaceCard(dynamic s)=>Card(margin:const EdgeInsets.only(bottom:10),child:ListTile(
    leading:const CircleAvatar(child:Icon(Icons.meeting_room)),
    title:Text(s['name']),subtitle:Text('${s['type']} · Capacidad ${s['capacity']}'),
    trailing:FilledButton(onPressed:()=>reserve(s),child:const Text('Reservar')),
    onTap:()=>showDialog(context:context,builder:(_)=>AlertDialog(
      title:Text(s['name']),content:Text('${s['description']}\\n\\nTipo: ${s['type']}\\nCapacidad: ${s['capacity']} personas'),
      actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Cerrar'))]))));

  Widget reservationsPage()=>FutureBuilder(
    future:api.reservations(),
    builder:(context,snap){
      if(snap.connectionState==ConnectionState.waiting)return const Center(child:CircularProgressIndicator());
      if(snap.hasError)return Center(child:Text('Error: ${snap.error}'));
      final list=snap.data as List<dynamic>;
      if(list.isEmpty)return const Center(child:Text('No tienes reservas todavía.'));
      return ListView(padding:const EdgeInsets.all(16),children:[
        Text('Mis reservas',style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.bold)),
        const SizedBox(height:12),
        ...list.map((r)=>Card(child:ListTile(
          leading:Icon(r['status']=='ACTIVE'?Icons.event_available:Icons.event_busy),
          title:Text(r['space']['name']),
          subtitle:Text('${r['date']} · ${r['time'].toString().substring(0,5)}\\nEstado: ${r['status']=='ACTIVE'?'Activa':'Cancelada'}'),
          trailing:r['status']=='ACTIVE'?IconButton(icon:const Icon(Icons.cancel),onPressed:()=>cancel(r)):null,
        )))
      ]);
    });

  Widget spacesPage()=>FutureBuilder(
    future:api.spaces(),builder:(context,snap){
      if(snap.connectionState==ConnectionState.waiting)return const Center(child:CircularProgressIndicator());
      if(snap.hasError)return Center(child:Text('Error: ${snap.error}'));
      final list=snap.data as List<dynamic>;
      return ListView(padding:const EdgeInsets.all(16),children:[
        Text('Espacios',style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.bold)),
        const SizedBox(height:8),const Text('Consulta las características antes de reservar.'),
        const SizedBox(height:12),...list.map(spaceCard)
      ]);
    });

  @override Widget build(BuildContext context){
    final pages=[home(),reservationsPage(),spacesPage()];
    return Scaffold(
      appBar:AppBar(title:const Text('UniReserve'),actions:[
        IconButton(icon:const Icon(Icons.logout),tooltip:'Cerrar sesión',onPressed:()async{await api.logout();if(mounted)Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>const LoginPage()),(_)=>false);})
      ]),
      body:pages[index],
      bottomNavigationBar:NavigationBar(selectedIndex:index,onDestinationSelected:(i)async{
        setState(()=>index=i);
        if(i==1)await loadMine();
        if(i==2)await loadSpaces();
      },destinations:const[
        NavigationDestination(icon:Icon(Icons.search),label:'Inicio'),
        NavigationDestination(icon:Icon(Icons.event_note),label:'Mis reservas'),
        NavigationDestination(icon:Icon(Icons.meeting_room),label:'Espacios'),
      ])
    );
  }
}
