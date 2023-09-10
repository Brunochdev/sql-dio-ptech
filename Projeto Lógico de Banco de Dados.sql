-- Criação do banco de dados para o cenário de e-commerce
-- drop database ecommerce;
create database ecommerce;
use ecommerce;

-- ## Fazendo a criação de tabelas ##

	-- Criando tabela cliente
create table cliente(
	idCliente int auto_increment primary key,
    primNome varchar (15),
    meioNome char (3),
    ultNome varchar (15),
    CPF char (11) not null,
    endereco varchar (100),
    constraint cpf_unico unique (CPF)
);

alter table cliente auto_increment=1;

-- ## Adicionando um campo para definir se o cliente será um 'PJ' ou 'PF', e um varchar de 14 caso seja CNPJ ##
alter table cliente
drop column CPF,
add documento VARCHAR(14) NOT NULL,
add tipoDocumento enum('CPF', 'CNPJ') not null;
-- ##

	-- Criando tabela produto
create table produto(
	idProduto int auto_increment primary key,
    prodNome varchar (30) not null,
    classEtaria bool default false,
    categoria enum ('Eletrônico', 'Vestuário', 'Alimento','Saúde','Móveis','Brinquedo') not null,
    avaliacao float default 0,
    dimEmbalagem varchar(10)
);

	-- Criando tabela pagamento
create table pagamento(
	idCliente int,
    idPagamento int,
    tipoPagamento enum ('Dinheiro', 'Cartão', 'Boleto', 'Pix'), 
	limite float,
    primary key (idCliente, idPagamento),
    foreign key (idCliente) references cliente(idCliente)
);


-- ## Inserindo forma de pagamento para o cliente ##
create table formas_pagamento (
    idPagamento int,
    tipoPagamento enum ('Dinheiro', 'Cartão', 'Boleto', 'Pix'),
    primary key (idPagamento)
);

alter table pagamento
add column idFormaPagamento int;

alter table pagamento
add constraint FK_formas_pagamento
foreign key (idFormaPagamento)
references formas_pagamento(idPagamento);
-- ##

	-- Criando tabela pedido
create table pedido(
	idPedido int auto_increment primary key,
	idPedidoCliente int,
	pedido enum('Confirmado', 'Cancelado', 'Processando') default 'Processando',
	desPedido varchar (255),
	frete float default 15.5,
	pagamento bool default false,
	constraint fk_pedido_cliente foreign key (idPedidoCliente) references cliente(idCliente)
);

-- ## Adicionando um campo para definir o código de rastreio ##
alter table pedido add codigoRastreio varchar(20);
##

	-- Criando tabela estoque
create table estoque(
	idProdEstoque int auto_increment primary key,
	localEstoque varchar (255),
	quantidade int default 0
);    
    
    -- Criando tabela fornecedor
create table fornecedor(
	idFornecedor int auto_increment primary key,
	razaoSocial varchar (255) not null,
	CNPJ char (15) not null,
	contato char (11) not null,
	constraint fornecedor_unico unique (CNPJ)
);    

    -- Criando tabela vendedor
create table vendedor(
	idVendedor int auto_increment primary key,
	razaoSocial varchar (255) not null,
	fantasia varchar (255),
	CNPJ char (15) not null,
	CPF char(9),
	localizacao varchar (255),
	contato char (11) not null,
	constraint vendedor_unico_cnpj unique (CNPJ),
	constraint vendedor_unico_cpf unique (CPF)
);        

	 -- Criando tabela vendedor/produto
create table vendedorProduto(
	idProdutoV int,
	idProduto int,
	produtoQuant int default 1,
	primary key (idProdutoV, idProduto),
	constraint fk_produto_vendedor foreign key (idProdutoV) references vendedor(idVendedor),
	constraint fk_produto_produto foreign key (idProduto) references produto(idProduto)
);             

	 -- Criando tabela pedido/produto
create table pedidoProduto(
	idPoProduto int,
	idPoPedido int,
	pedidoQuant int default 1,
	pedidoStatus enum('Disponível', 'Sem Estoque') default 'Disponível',
	primary key (idPoProduto, idPoPedido),
	constraint fk_produtopedido_vendedor foreign key (idPoProduto) references produto(idProduto),
	constraint fk_produtopedido_produto foreign key (idPoPedido) references pedido(idPedido)
);             

	 -- Criando tabela localização/estoque
create table localEstoque(
	idLocProduto int,
	idLocEstoque int,
	location varchar (255) not null,
	primary key (idLocProduto, idLocEstoque),
	constraint fk_estoque_local_produto foreign key (idLocProduto) references produto(idProduto),
	constraint fk_estoque_local_estoque foreign key (idLocEstoque) references estoque(idProdEstoque)
);             

	-- Criando tabela produto/fornecedor
create table produtoFornecedor(
	idPsFornecedor int,
    idPsProduto int,
    quantidade int not null,
    primary key (idPsFornecedor, idPsProduto),
    constraint fk_produto_fornecedor_fornecedor foreign key (idPsFornecedor) references fornecedor(idFornecedor),
	constraint fk_produto_fornecedor_produto foreign key (idPsProduto) references produto(idProduto)
);

-- ## Criando uma tabela para descobrir a relação entre vendedores e fornecedores ##
create table vendedorFornecedor (
    idVendedor int,
    idFornecedor int,
    primary key (idVendedor, idFornecedor)
);
-- ##


-- ## INSERINDO DADOS NAS TABELAS ##

	-- Inserindo dados na tabela cliente
-- primNome, meioNome, ultNome, CPF, endereco
insert into cliente (primNome, meioNome, ultNome, documento, endereco)
	values ('Maria','M','Silva','123456789','rua selva de prata 29, Carangola - Cidade das Flores'),
		   ('Matheus','O','Pimentel','987654321','rua alameda 289, Centro - Cidade das Flores'),	
           ('Ricardo','F','Silva','45678913','avenida alameda vinha 1009, Centro - Cidade das Flores'),
		   ('Julia','S','França','789123456','rua laranjeiras 861, Centro - Cidade das Flores'),
           ('Roberta','G','Assis','98745631','avenida koller 19, Centro - Cidade das Flores'),
		   ('Isabela','M','Cruz','654789123','rua alameda das flores 28, Centro - Cidade das Flores');
           
	-- Inserindo dados na tabela produto           
  -- prodNome, classEtaria, categoria, avaliacao, dimEmbalagem         
insert into produto (prodNome, classEtaria, categoria, avaliacao, dimEmbalagem)
	values ('Fone de ouvido', false, 'Eletrônico','4', null), 
		   ('Barbie Elsa', true, 'Brinquedo','3', null),
           ('Body Carters', true, 'Vestuário','5', null),
           ('Microfone Vedo - Youtuber', false, 'Eletrônico','4', null),
           ('Sofá Retrátil', false, 'Móveis','3', '3x57x80'),
           ('Farinha de arroz', false, 'Alimento','2', null),
           ('Fire Stick Amazon', false, 'Eletrônico','3', null);
           

delete from pedido where idPedidoCliente in (1, 2, 3, 4);

		-- Inserindo dados na tabela pedido
-- idPedido, idPedidoCliente, pedido, desPedido, frete, pagamento
insert into pedido (idPedidoCliente, pedido, desPedido, frete, pagamento)
	values (1, default, 'compra via app', null, 1), 
		   (2, default, 'compra via app', 50, 0), 
           (3, 'confirmado', null, null, 1), 
           (4, default, 'compra via web site', 150, 0);

	-- Inserindo dados na tabela pedidoProduto
-- idPoProduto, idPoPedido, pedidoQuant, pedidoStatus     
insert into pedidoProduto(idPoProduto, idPoPedido, pedidoQuant, pedidoStatus)
	values (1, 1, 2, null),
		   (2, 1, 1, null),
           (3, 2, 1, null);
   
	-- Inserindo dados na tabela estoque   
-- localEstoque, quantidade           
insert into estoque(localEstoque, quantidade)
	values ('Rio de Janeiro', 1000),
		   ('Rio de Janeiro', 500),
           ('São Paulo', 10),
           ('São Paulo', 100),
           ('São Paulo', 10),
           ('Brasília', 60);

	-- Inserindo dados na tabela localEstoque
-- idLocProduto, idLocEstoque, location
insert into localEstoque(idLocProduto, idLocEstoque, location)
	values (1, 2, 'RJ'),
		   (2, 6, 'GO');
           
	-- Inserindo dados na tabela fornecedor           
-- razaoSocial, CNPJ, contato           
insert into fornecedor(razaoSocial, CNPJ, contato)
	values ('Almeida e Filhos', 123456789123456, '21985474'),
		   ('Eletrônicos Silva', 854519649143457, '21985484'),
           ('Elerônicos Valma', 934567893934695, '21975474');
           
	-- Inserindo dados na tabela produtoFornecedor		  
-- idPsFornecedor, idPsProduto, quantidade         
insert into produtoFornecedor(idPsFornecedor, idPsProduto, quantidade)
	values (1, 1, 500),
		   (1, 2, 400),
           (2, 4, 633),
           (3, 3, 5),
           (2, 5, 10);
           
	-- Inserindo dados na tabela vendedor           
-- razaoSocial, fantasia, CNPJ, CPF, localizacao, contato    
insert into vendedor(razaoSocial, fantasia, CNPJ, CPF, localizacao, contato)
	values ('Tech Eletronics', null, 123456789456321, null, 'Rio de Janeiro', 219946287), 
		   ('Botique Durgas', null, 456789213654485, 123456783, 'Rio de Janeiro', 219567895), 
           ('Kids World', null, 456789123654485, null, 'São Paulo', 1198657484);

	-- Inserindo dados na tabela vendedorProduto
-- idProdutoV, idProduto, produtoQuant
insert into vendedorProduto(idProdutoV, idProduto, produtoQuant)
	values (1, 6, 80),
           (2, 7, 10);

 
-- ## CONSULTAS ##

-- Total de pedidos feitos por cada cliente:
select c.primNome, count(p.idPedido) as total_pedidos
from cliente c
left join pedido p on c.idCliente = p.idPedidoCliente
group by c.primNome;           
           
-- Essa consulta usa uma tabela criada posteriormente            
-- Consultar se algum vendedor também é fornecedor:
select distinct v.razaoSocial as vendedor, f.razaoSocial as fornecedor
from vendedorFornecedor vf
inner join vendedor v on vf.idVendedor = v.idVendedor
inner join fornecedor f on vf.idFornecedor = f.idFornecedor;
           
-- Consulta de produtos vendidos por um vendedor em específico:
select p.prodNome
from produto p
inner join vendedorProduto vp on p.idProduto = vp.idProduto
inner join vendedor v on vp.idProdutoV = v.idVendedor
where v.razaoSocial = 'Nome do Vendedor'; -- deve ser colocado o nome da razão social específica           
         
-- Consulta de pedidos com status 'Confirmado':
select * from pedido where pedido = 'Confirmado';

-- Recuperar produtos de um fornecedor específico:
select p.prodNome
from produtoFornecedor pf
inner join produto p on pf.idPsProduto = p.idProduto
where pf.idPsFornecedor = 2; -- nesse caso usando a identificação '2'

-- Relação de produtos fornecedores e estoque:
select pf.idPsFornecedor, pf.idPsProduto, pf.quantidade as quantidade_fornecida, e.localEstoque, e.quantidade as quantidade_em_estoque
from produtoFornecedor pf
inner join estoque e on pf.idPsProduto = e.idProdEstoque;

-- Relação de nomes dos fornecedores e nomes dos produtos:      
select f.razaoSocial as fornecedor, p.prodNome as produto
from produtoFornecedor pf
inner join fornecedor f on pf.idPsFornecedor = f.idFornecedor
inner join produto p on pf.idPsProduto = p.idProduto;