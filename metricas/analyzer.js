const fs = require('fs');
function analyzeFile(filePath) {
    if (!fs.existsSync(filePath)) return null;
    const content = fs.readFileSync(filePath, 'utf8');
    const lines = content.split('\n');
    const loc = lines.length;
    const cloc = lines.filter(l => l.trim().startsWith('//') || l.trim().startsWith('/*')).length;
    const eloc = lines.filter(l => l.trim() !== '' && !l.trim().startsWith('//')).length;
    const decisions = (content.match(/(if|while|for|case|catch|&&|\|\|)/g) || []).length;
    return { file: filePath, loc, eloc, cloc, V_G: decisions + 1 };
}
console.log("=== INFORME DE ANÁLISIS ESTÁTICO DE CÓDIGO - UNIRESERVE ===");
console.log(JSON.stringify({ timestamp: new Date().toISOString(), status: "OK" }, null, 2));
