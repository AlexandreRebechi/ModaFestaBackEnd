

CREATE TABLE IF NOT EXISTS pessoas(
	cpf varchar(14) primary key not null,
	nome_cliente varchar(100) ,
	nome_funcionario varchar(100),
	email varchar(100) not null,
	telefone varchar(15) not null,
	cep varchar(9) not null,
	logradouro varchar(50) not null,
	bairro varchar(50) not null,
	numero varchar(50) not null,
	complemento varchar(50) not null,
	observacoes varchar(300) not null,
	data_cadastro TIMESTAMP not null   DEFAULT now(),
	username varchar(50) not null,
	password varchar(6) not null,
	data_ultimo_login TIMESTAMP ,
	tipo char(1) not null check(tipo = 'C' or tipo = 'F')
);

insert into pessoas (cpf, nome_cliente, email, telefone, cep, logradouro, bairro, numero, complemento,observacoes, data_cadastro, username, password, data_ultimo_login, tipo) 
                    values('83183140004', 'nome_cliente1', 'teste_cliente1@email', '1223456798', '345435', 'logradouro1', 'bairro_cliente1', '7575756', 'complemento1', 'observacoes1', now(), 'username_cliente1', '1234', now(), 'C') 

insert into clientes (rg, cnpj, ie, cpf_pessoa, tipo) values ('303897296','28949295000166', '5955110719', '83183140004', 'J') returning rg, cnpj, ie



CREATE TABLE perfis (
	id serial not null primary key ,
	descricao text not null
);

insert into perfis (descricao) values('descricao_perfil1')

CREATE TABLE funcionalidades (
	id serial not null primary key,
	descricao text not null
	
	
);

insert into funcionalidades (descricao) values('descricao_funcionalidades1')

CREATE TABLE perfis_funcionalidades (
	id_funcionalidade integer not null,
	id_perfil integer not null,
	foreign key (id_funcionalidade) references funcionalidades (id),
	foreign key (id_perfil) references perfis (id),
	primary key(id_funcionalidade, id_perfil)
	
);
insert into perfis_funcionalidades(id_funcionalidade, id_perfil) values(1, 1)

select f.id, f.descricao from funcionalidades f, perfis_funcionalidades pf where pf.id_funcionalidade = f.id and pf.id_funcionalidade = 1



CREATE TABLE IF NOT EXISTS clientes(
	rg varchar(9),
	cnpj varchar(14),
	ie varchar(14),
	cpf_pessoa varchar(14),
	tipo char(1) not null check(tipo = 'F' or tipo = 'J'),
	foreign key (cpf_pessoa) references pessoas (cpf)
);


CREATE TABLE IF NOT EXISTS funcionarios (
	numero_ctps varchar(50),
	data_contratacao TIMESTAMP not null,
	data_demissao TIMESTAMP not null,
	perfil integer not null,
	cpf_pessoa varchar(14) not null,
	foreign key (cpf_pessoa) references pessoas (cpf),
	foreign key (perfil) references perfis (id)
); 

insert into pessoas (cpf, nome_funcionario, email, telefone, cep, logradouro, bairro, numero, complemento,observacoes, data_cadastro, username, password, data_ultimo_login, tipo) 
                    values('19700178056', 'nome_funcionario1', 'teste_funcionario1@email', '1223456798', '345435', 'logradourofuncionario1', 'bairro_funcionario1', '7575756', 'complementofuncionario1', 'observacoesfuncionario1', now(), 'username_clientefuncionario1', '123456', now(), 'F')  

insert into funcionarios (numero_ctps, data_contratacao, data_demissao, perfil, cpf_pessoa) 
                    values('60804073086', now(), now(), 1, '19700178056') 

CREATE TYPE statusReserva as ENUM('EM_ANALISE', 'APROVADA', 'NEGADA');

CREATE TABLE reservas (
	id serial not null primary key,
	data_inicio date not null,
	data_fim date not null,
	valor numeric(7,2) not null,
	--valor_frete numeric(7,2) not null,
	valor_entrega numeric(7,2),
	valor_total numeric(7,2) not null,
	observacoes varchar(300) not null,
	cliente varchar(14) not null,
	funcionario varchar(14),
	status_reserva statusReserva not null,
	--status_reserva string not null,
	foreign key (cliente) references pessoas (cpf),
	foreign key (funcionario) references pessoas (cpf)


);

select r.id, r.data_inicio, r.data_fim, r.valor, r.valor_entrega, r.valor_total, r.observacoes, p.nome_cliente, p.nome_funcionario, r.status_reserva, 0 as produtos
from reservas as r inner join pessoas as p
on (r.cliente = p.cpf) 
MINUTE
select r.id, r.data_inicio, r.data_fim, r.valor, r.valor_entrega, r.valor_total, r.observacoes,p.nome_cliente,p.nome_funcionario, r.status_reserva, 0 as produtos
from reservas as r inner join pessoas as p
on (r.funcionario = p.cpf) ;

	




select r.id, 
                to_char(r.data_inicio, 'yyyy-mm-dd') as data_inicio,
                to_char(r.data_fim, 'yyyy-mm-dd') as data_fim, 
                r.valor, r.valor_entrega, r.valor_total, r.observacoes, r.cliente, r.funcionario, r.status_reserva 
                from reservas r 
                order by r.id asc;
select p.id, p.descricao,  p.observacoes, p.valor_custo, p.valor_aluguel, p.valor_venda, p.tipo_produto 
from produtos p, reservas_produtos rp 
where rp.id_produto = p.id and rp.id_produto = 1

CREATE TABLE tiposProduto (
	id serial not null primary key,
	nome varchar(50) not null
);

CREATE TABLE produtos (
	id serial not null primary key,
	descricao varchar(300) not null,
	observacoes varchar(300) not null,
	valor_custo numeric(7,2) not null,
	valor_aluguel numeric(7,2) not null,
	valor_venda numeric(7,2) not null,
	tipo_produto integer not null,
	--foreign key (id_foto) references fotos (id),
	foreign key (tipo_produto) references tiposProduto (id)
	
	
);
CREATE TABLE reservas_produtos(
	id_reserva integer not null ,
	id_produto integer not null ,
	foreign key(id_reserva) references reservas (id),
	foreign key(id_produto) references produtos (id),
	primary key(id_reserva, id_produto)

);





CREATE TABLE fotos (
	id serial not null primary key,
	descricao varchar(300) not null,
	b64 text not null,
	produto_id integer not null,
	foreign key (produto_id) references produtos (id)
	
	
);

CREATE TYPE tiposPagamento as ENUM('NA_RETIRADA', 'ENTRADA_DEVOLUCAO', 'PARCELADO');

CREATE TABLE locacoes (
	id serial not null primary key,
	data_retirada date not null,
	data_previsao_entrega date not null,
	data_entrega date null,
	data_previsao_pagamento date not null,
	valor_total numeric(7,2) not null,
	valor_pago numeric(7,2) not null,
	valor_frete numeric(7,2) not null,
	observacoes varchar(300) not null,
	funcionario varchar(14) not null,
	
	tipos_pagamento tiposPagamento not null,
	foreign key (funcionario) references pessoas(cpf)
	
	
	
	
);




CREATE TABLE locacoes_reservas(
	id_locacao integer not null,
	id_reserva integer not null,
	foreign key (id_locacao) references locacoes(id),
	foreign key (id_reserva) references reservas(id),
	primary key(id_locacao, id_reserva)

);

CREATE TABLE parcelamentos (
	id serial not null primary key,
	numero_parcela integer not null,
	data_previsao_pagamento date not null,
	data_pagamento date null,
	valor_total numeric(7,2) not null,
	valor_pago numeric(7,2) not null,
	id_locacao integer not null,
	foreign key(id_locacao) references locacoes (id)
	
	
);
CREATE TABLE situacao (
	id serial not null primary key,
	descricao varchar(300) not null
);

CREATE TABLE acompanhamento (
	id serial not null primary key,
	statusLocacao statusLocacao not null,
	data date not null,
	observacoes varchar(300) not null,
	id_locacao integer not null,
	foreign key (id_locacao) references locacoes(id)
	
);

CREATE TYPE statusLocacao as ENUM('EM_ATRASO', 'AGUARDANDO_RETIRADA', 'EM_PREPARAÇÃO', 'CONCLUIDO')

