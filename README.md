# README - Banco de Dados de Oficina 
- #### Este README fornece informações sobre a criação e estruturação de um banco de dados para um cenário de uma oficina. O banco de dados é criado usando comandos SQL e é composto por várias tabelas que representam entidades relacionadas ao funcionamento de um negócio de comércio eletrônico. ## 
#
## Diagrama Entidade Relacionamento #  

![plbde](https://github.com/Brunochdev/sql-dio-ptech/blob/Brunochdev-sql-desafio2/plbdo.jpg)

#
    # Estrutura do Banco de Dados #
O banco de dados da oficina mecânica consiste em várias tabelas interligadas para gerenciar informações sobre clientes, veículos, serviços, peças de reposição, funcionários e ordens de serviço. Abaixo está a lista das tabelas e suas principais colunas:

    Tabela cliente

idCliente: Identificador único do cliente (chave primária).  
primNome: Primeiro nome do cliente.  
meioNome: Nome do meio do cliente (pode estar vazio).  
ultNome: Último sobrenome do cliente.  
documento: CPF ou CNPJ do cliente.  
endereco: Endereço de entrega do cliente.  
tipoDocumento: Indica se o documento é um CPF ou CNPJ. Pode ter os valores "CPF" ou "CNPJ". 
#
    Tabela veiculo

idVeiculo: Identificador único do veículo (chave primária).  
placa: Placa do veículo.  
marca: Marca do veículo.  
modelo: Modelo do veículo.  
ano: Ano de fabricação do veículo.  
idCliente: Identificador do cliente a quem pertence o veículo (chave estrangeira referenciando a tabela "cliente").
#
    Tabela servico

idServico: Identificador único do serviço (chave primária).  
descricao: Descrição do serviço.  
preco: Preço do serviço.
#
    Tabela ordem_servico

idOrdemServico: Identificador único da ordem de serviço (chave primária).  
idVeiculo: Identificador do veículo relacionado à ordem de serviço (chave estrangeira referenciando a tabela "veiculo").  
dataEntrada: Data de entrada da ordem de serviço.  
dataSaida: Data de saída da ordem de serviço (pode ser nulo se o serviço não estiver concluído).
#
    Tabela item_ordem_servico

idItemOrdemServico: Identificador único do item da ordem de serviço (chave primária).  
idOrdemServico: Identificador da ordem de serviço à qual o item pertence (chave estrangeira referenciando a tabela "ordem_servico").  
idServico: Identificador do serviço realizado no item (chave estrangeira referenciando a tabela "servico"). 
#
    Tabela peca_reposicao

idPeca: Identificador único da peça de reposição (chave primária).  
nome: Nome da peça de reposição.  
descricao: Descrição da peça de reposição.  
estoque: Quantidade em estoque da peça de reposição.  
preco: Preço da peça de reposição.
#
    Tabela peca_ordem_servico

idPecaOrdemServico: Identificador único do registro de peça na ordem de serviço (chave primária).  
idPeca: Identificador da peça de reposição utilizada na ordem de serviço (chave estrangeira referenciando a tabela "peca_reposicao").  
idOrdemServico: Identificador da ordem de serviço à qual a peça pertence (chave estrangeira referenciando a tabela "ordem_servico").
#
	Tabela pagamento

idCliente: Identificador do cliente relacionado ao pagamento (chave estrangeira referenciando a tabela "cliente").  
idPagamento: Identificador único do pagamento (parte da chave primária).  
tipoPagamento: Tipo de pagamento utilizado, que pode ser "Dinheiro", "Cartão", "Boleto" ou "Pix".  
limite: Limite de pagamento relacionado ao cliente.
#
    Tabela formas_pagamento

idPagamento: Identificador único da forma de pagamento (chave primária).  
tipoPagamento: Tipo de pagamento, que pode ser "Dinheiro", "Cartão", "Boleto" ou "Pix".
#  
    Tabela funcionario

idFuncionario: Identificador único do funcionário (chave primária).  
nome: Nome completo do funcionário.  
cargo: Cargo ou função do funcionário.  
salario: Salário do funcionário.  
dataContratacao: Data de contratação do funcionário.
#
	Tabela historico_servico

idHistoricoServico: Identificador único do registro de histórico de serviço (chave primária).  
idOrdemServico: Identificador da ordem de serviço associada ao histórico (chave estrangeira referenciando a tabela "ordem_servico").  
dataServico: Data em que o serviço foi realizado.  
idFuncionario: Identificador do funcionário que executou o serviço (chave estrangeira referenciando a tabela "funcionario").
#
    

 ## Criação e Preenchimento do Banco de Dados ##
O banco de dados pode ser criado utilizando os comandos SQL fornecidos no a partir de agora neste README.
#
- ## Início do Banco de Dados ##

-- drop database oficina;  
(Tire o pontilhado para executar um comando que exclui seu banco de dados e inicie do zero se precisar)  

create database oficina;  
-- cria um banco de dados com o nome de oficina 

use oficina;  
-- para iniciar o banco de dados com o nome de oficina  

- ### Fazendo a criação de tabelas ###  
#
	-- Criando tabela cliente
create table cliente (  
    idCliente int auto_increment primary key,  
    nome varchar(100) not null,  
    cpf char (11) not null,  
    telefone varchar(15),  
    email varchar(100),  
    endereco varchar(255)  
);  
#
- #### Ateração na tabela cliente para retirar a coluna "CPF" e inserir uma nova coluna chamada "documento", onde será possível incluir dados de CPF ou CNPJ , além de constraint para definir um email por pessoa apenas. ####

alter table cliente  
add constraint unique_email unique (email),  
drop column cpf,  
add documento VARCHAR(14) NOT NULL,  
add tipoDocumento enum('CPF', 'CNPJ') not null;

#
	-- Criando tabela veículo
create table veiculo (  
    idVeiculo int auto_increment primary key,  
    placa varchar(10) not null,  
    marca varchar(50),  
    modelo varchar(50),  
    ano int,  
    idCliente int,  
    foreign key (idCliente) references cliente(idCliente)  
);
#
	-- Criando tabela serviço
create table servico (  
    idServico int auto_increment primary key,  
    descricao varchar(255) not null,  
    preco decimal(10, 2) not null  
);
#
	-- Criando tabela ordem de serviço
create table ordem_servico (  
    idOrdemServico int auto_increment primary key,  
    idVeiculo int,  
    dataEntrada date not null,  
    dataSaida date,  
    foreign key (idVeiculo) references veiculo(idVeiculo)  
);
#
	-- Criando tabela item da ordem de serviço
create table item_ordem_servico (   
    idItemOrdemServico int auto_increment primary key,  
    idOrdemServico int,  
    idServico int,  
    foreign key (idOrdemServico) references ordem_servico(idOrdemServico),  
    foreign key (idServico) references servico(idServico)  
);
#
	-- Criando tabela peça de reposição
create table peca_reposicao (  
    idPeca int auto_increment primary key,  
    nome varchar(100) not null,  
    descricao varchar(255),  
    estoque int,  
    preco decimal(10, 2) not null  
);
#    
    -- Criando tabela peça da ordem de serviço
create table peca_ordem_servico (  
    idPecaOrdemServico int auto_increment primary key,  
    idPeca int,  
    idOrdemServico int,  
    foreign key (idPeca) references peca_reposicao(idPeca),  
    foreign key (idOrdemServico) references ordem_servico(idOrdemServico)  
);
#
    -- Criando tabela pagamento
create table pagamento(  
	idCliente int,  
    idPagamento int,  
    tipoPagamento enum ('Dinheiro', 'Cartão', 'Boleto', 'Pix'),   
	limite float,  
    primary key (idCliente, idPagamento),  
    foreign key (idCliente) references cliente(idCliente)  
);
#
	-- Criando tabela formas de pagamento
create table formas_pagamento (  
    idPagamento int,  
    tipoPagamento enum ('Dinheiro', 'Cartão', 'Boleto', 'Pix'),  
    primary key (idPagamento)  
);
#
- #### Ateração na tabela pagamento ####
alter table pagamento  
add column idFormaPagamento int,   
add constraint FK_formas_pagamento  
foreign key (idFormaPagamento) references formas_pagamento(idPagamento);  
#
	-- Criando tabela funcionário
create table funcionario (  
    idFuncionario int auto_increment primary key,  
    nome varchar(100) not null,  
    cargo varchar(50),  
    salario decimal(10, 2),  
    dataContratacao date  
);
#
	-- Criando tabela histórico de serviço
create table historico_servico (  
    idHistoricoServico int auto_increment primary key,  
    idOrdemServico int,  
    dataServico date,  
    idFuncionario int,  
    foreign key (idOrdemServico) references ordem_servico(idOrdemServico),  
    foreign key (idFuncionario) references funcionario(idFuncionario)  
);
#
- ### INSERINDO DADOS NAS TABELAS ###
#
    --Inserindo dados na tabela cliente   
    
-- nome, documento, telefone, email, endereco  
insert into cliente (nome, documento, telefone, email, endereco)   

	values 	('João Silva', '12345678901', '123-456-7890', 'joao@email.com', 'Rua A, 123'),
			('Maria Santos', '23456789012', '987-654-3210', 'maria@email.com', 'Avenida B, 456'),
			('Carlos Oliveira', '34567890123', '555-555-5555', 'carlos@email.com', 'Rua C, 789'),
			('Ana Souza', '45678901234', '111-222-3333', 'ana@email.com', 'Rua D, 101'),
			('Pedro Almeida', '56789012345', '777-888-9999', 'pedro@email.com', 'Rua E, 55'),
			('Fernanda Pereira', '67890123456', '333-444-5555', 'fernanda@email.com', 'Avenida F, 12'),
			('Ricardo Mendes', '78901234567', '999-999-9999', 'ricardo@email.com', 'Rua G, 8'),
			('Isabela Lima', '89012345678', '222-333-4444', 'isabela@email.com', 'Avenida H, 22');
#                               
    --Inserindo dados na tabela veículo

  -- placa, marca, modelo, ano, idCliente        
insert into veiculo (placa, marca, modelo, ano, idCliente)

	values 	('ABC123', 'Ford', 'Focus', 2020, 1),
			('XYZ789', 'Toyota', 'Corolla', 2019, 2),
			('LMN456', 'Honda', 'Civic', 2021, 3),
			('PQR789', 'Chevrolet', 'Cruze', 2018, 4),
			('JKL321', 'Volkswagen', 'Golf', 2022, 5),
			('DEF456', 'Hyundai', 'Elantra', 2017, 6),
			('GHI987', 'Nissan', 'Sentra', 2020, 7),
			('MNO654', 'Kia', 'Optima', 2019, 8);
           
#
		-- Inserindo dados na tabela serviço

-- descricao, preco  
insert into servico (descricao, preco)

	values 	('Troca de óleo', 50.00),
			('Balanceamento', 25.00),
			('Alinhamento', 40.00),
			('Troca de filtro', 15.00),
			('Reparo de sistema de ar condicionado', 150.00);
#	
    -- Inserindo dados na tabela ordem de serviço
-- idVeiculo, dataEntrada, dataSaida  
insert into ordem_servico (idVeiculo, dataEntrada, dataSaida)  

	values 	(1, '2022-09-01', '2022-09-03'),  
			(2, '2023-07-02', '2023-07-05'),  
			(3, '2021-03-03', '2021-03-04'), 
			(4, '2023-08-04', NULL),  
			(5, '2023-09-05', '2023-09-05'),  
			(6, '2022-05-06', NULL);    
#   
	-- Inserindo dados na tabela item da ordem de serviço
-- idOrdemServico, idServico           
insert into item_ordem_servico (idOrdemServico, idServico) 

	values	(1, 1),
			(1, 2),
			(2, 3),
			(3, 4),
			(4, 5);
#
	-- Inserindo dados na tabela peça de reposição
-- nome, descricao, estoque, preco
insert into peca_reposicao (nome, descricao, estoque, preco)

		values	('Filtro de óleo', 'Filtro de óleo', 100, 5.99),
				('Pastilhas de freio', 'Pastilhas de freio', 50, 25.50),
				('Velas de ignição', 'Velas de ignição', 80, 8.99),
				('Correia dentada', 'Correia dentada', 30, 15.75),
				('Lâmpada de farol', 'Lâmpada de farol', 60, 4.49),
				('Bateria de carro', 'Bateria de 12V', 20, 69.99),
				('Pneu aro 15', 'Pneu', 40, 89.95),
				('Amortecedor dianteiro', 'Amortecedor dianteiro', 35, 35.75); 
#           
	-- Inserindo dados na tabela peça da ordem de serviço          
-- idPeca, idOrdemServico          
insert into peca_ordem_servico (idPeca, idOrdemServico)

	values	(1, 1),
			(2, 1),
			(3, 2),
			(4, 3),
			(5, 4),
			(6, 5);
#           
	-- Inserindo dados na tabela funcionário		  
-- nome, cargo, salario, dataContratacao         
insert into funcionario (nome, cargo, salario, dataContratacao) 

	values	('João da Silva', 'Mecânico', 2500.00, '2022-03-15'),
			('Maria Santos', 'Atendente', 2000.00, '2023-01-10'),
			('Carlos Oliveira', 'Gerente', 3500.00, '2021-06-20'),
			('Ana Souza', 'Mecânico', 2600.00, '2022-08-05'),
			('Pedro Almeida', 'Atendente', 2100.00, '2023-04-12'),
			('Fernanda Pereira', 'Mecânica', 2700.00, '2023-02-28'),
			('Ricardo Mendes', 'Gerente', 3800.00, '2021-03-10'),
			('Isabela Lima', 'Atendente', 2200.00, '2023-05-22');   
#           
	-- Inserindo dados na tabela histórico de serviço           
-- idOrdemServico, dataServico, idFuncionario   
insert into historico_servico (idOrdemServico, dataServico, idFuncionario) 

	values	(1, '2023-09-03', 1),
			(1, '2023-09-04', 3),
			(2, '2023-09-05', 2),
			(3, '2023-09-06', 1),
			(4, '2023-09-07', 4);
#

 - ### CONSULTAS ###
#
- ## Recuperações simples com SELECT Statement; ##
#
  	-- consulta simples para retornar os dados de todos os clientes  
select * from cliente;  
#
	-- consulta simples para retornar os dados de todos os serviços
select * from servico;
#
	-- consulta simples para retornar os dados de todos os funcionários
select * from funcionario;	
#
	-- consulta para retornar dados dos veículos dos clientes
select v.*, c.nome as nome_cliente  
from veiculo v  
join cliente c on v.idCliente = c.idCliente;
#
	-- consulta para retornar dados de entrada e saída (se houver) de serviços
select os.*, v.placa, c.nome as nome_cliente  
from ordem_servico os  
join veiculo v on os.idVeiculo = v.idVeiculo  
join cliente c on v.idCliente = c.idCliente;
#	
	-- selecionar todas as peças usadas em uma ordem de serviço específica (exemplo serviço com id 4)
select pos.*, pr.nome as peca_nome  
from peca_ordem_servico pos  
join peca_reposicao pr on pos.idPeca = pr.idPeca  
where pos.idOrdemServico = 4;
#  
- ## Filtros com WHERE Statement; ##
#
	-- selecionar ordens de serviço que ainda não foram concluídas 
select * from ordem_servico where dataSaida is null;
#
	-- Selecionar todas as peças de reposição com estoque menor que 50 unidades
select * from peca_reposicao where estoque < 50;
#
	-- funcionários com salários maiores que 2.500 e foram contratados após 01/01/2023
select * from funcionario where salario > 2500.00 and dataContratacao > '2023-01-01';
#
- ## Expressões para gerar atributos derivados; ##
#  
	-- calcular o valor total de uma ordem de serviço com base nos serviços selecionados  
select os.idOrdemServico, sum(s.preco) as valor_total  
from ordem_servico os  
join item_ordem_servico ios on os.idOrdemServico = ios.idOrdemServico  
join servico s on ios.idServico = s.idServico  
group by os.idOrdemServico;
#
	-- calcular o número total de serviços realizados por cada funcionário
select hist.idFuncionario, count(*) as total_servicos_realizados  
from historico_servico hist  
group by hist.idFuncionario;
#
- ## Ordenações dos dados com ORDER BY; ##
#  
	-- ordenar clientes por nome em ordem alfabética crescente
select * from cliente
order by nome asc;
#
	-- ordena o funcionário com maior salário primeiro
select * from funcionario
order by salario desc;
#
	-- ordena peças com menor quantidade em estoque
select * from peca_reposicao
order by estoque asc;
#
- ## Condições de filtros aos grupos – HAVING Statement; ##
#
	-- seleciona funcionários que realizaram serviços em pelo menos duas ordens de serviço diferentes
select f.nome, count(distinct hs.idOrdemServico) as total_ordens  
from funcionario f  
join historico_servico hs on f.idFuncionario = hs.idFuncionario  
group by f.nome  
having count(distinct hs.idOrdemServico) >= 2;
#
	-- seleciona clientes que têm mais de um veículo registrado, e cujo total de veículos seja menor que 2
select c.nome, count(v.idVeiculo) as total_veiculos  	
from cliente c  
join veiculo v on c.idCliente = v.idCliente  
group by c.nome  
having count(v.idVeiculo) < 2;
#
- ## Criando junções entre tabelas para fornecer uma perspectiva mais complexa dos dados; ##
#    
	-- esta consulta junta as informações de clientes e seus veículos com base no "idCliente"
select c.nome as nome_cliente, v.placa, v.marca, v.modelo  
from cliente c  
inner join veiculo v on c.idCliente = v.idCliente;
#    
	-- esta consulta junta as informações de cliente, veículo e ordem de serviço, fornecendo inclusive se o serviço já foi concluído
select c.nome as nome_cliente, v.placa, os.idOrdemServico, os.dataEntrada, os.dataSaida  
from cliente c  
inner join veiculo v on c.idCliente = v.idCliente  
inner join ordem_servico os on v.idVeiculo = os.idVeiculo;
