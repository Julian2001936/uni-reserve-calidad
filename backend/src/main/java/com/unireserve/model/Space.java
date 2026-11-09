package com.unireserve.model;

import jakarta.persistence.*;

@Entity
@Table(name="spaces")
public class Space {
    @Id @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long id;
    @Column(nullable=false) private String name;
    @Column(nullable=false) private String type;
    @Column(nullable=false) private Integer capacity;
    @Column(nullable=false, length=500) private String description;
    @Column(nullable=false) private Boolean active = true;

    public Space(){}
    public Space(String name,String type,Integer capacity,String description){
        this.name=name; this.type=type; this.capacity=capacity; this.description=description; this.active=true;
    }
    public Long getId(){return id;}
    public String getName(){return name;}
    public void setName(String v){name=v;}
    public String getType(){return type;}
    public void setType(String v){type=v;}
    public Integer getCapacity(){return capacity;}
    public void setCapacity(Integer v){capacity=v;}
    public String getDescription(){return description;}
    public void setDescription(String v){description=v;}
    public Boolean getActive(){return active;}
    public void setActive(Boolean v){active=v;}
}
