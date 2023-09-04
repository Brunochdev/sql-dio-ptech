create schema if not exists company; # criação de um esquema
use company;

create table company.employee(  #cria uma tabela employee dentro do esquema
	Fname varchar(15) not null, #tamanho 15 bytes com constraint not null para não poder ter valor nulo
	Minit char, #valor simples pois é abreviação e pode não ter nome do meio
	Lname varchar(15) not null,
	Ssn char(9) not null, #seta char para que sejam exatamente nove dígitos
	Bdate DATE,
	Adress varchar(30),
	Sex char,
	Salary decimal(10,2), #10 dígitos para o número inteiro e mais dois após a vírgula
    Super_ssn char (9),
    Dno int not null,
    primary key (Ssn) #chave primária vai ser relacionada a Ssn
);

use company; #entra no banco de dados company	
create table department(
	Dname varchar(15) not null,
    Dnumber int not null,
    Mgr_ssn char (9),
    Mgr_start_date date,
    primary key (Dnumber),
    unique (Dname), #seja único, nome único
    foreign key (Mgr_ssn) references employee(Ssn) #o Mgr dessa tabela referencia o Ssn da tabela employee
);

create table dept_locations(
	Dnumber int not null,
    Dlocation varchar(15) not null,
    primary key (Dnumber, Dlocation), #chave composta
    foreign key (Dnumber) references department(Dnumber) #referencia atributo com mesmo nome (não tem problema)
);

create table project(
	Pname varchar(15) not null,
    Pnumber int not null,
    Plocation varchar(15),
    Dnum int not null,
    primary key (Pnumber),
    unique (Pname),
    foreign key (Dnum) references department(Dnumber)
    
);

create table works_on(
	Essn char(9) not null,
    Pno int not null,
    Hours decimal(3,1) not null,
    primary key (Essn, Pno), #composta herdando Essn do employee e Pno da project
    foreign key (Essn) references employee(Ssn),
    foreign key (Pno) references project(Pnumber)
);

create table dependent(
	Essn char(9) not null,
    Dependent_name varchar(15) not null,
    Sex char,
    Bdate date,
    Relationship varchar(8),
	primary key (Essn, Dependent_name),
    foreign key (Essn) references employee(Ssn)
);

show tables; #mostra todas as tabelas criadas
desc employee; #'descreve' a tabela com todos os dados inseridos
desc works_on; #pode acessar executando apenas essa linha 68