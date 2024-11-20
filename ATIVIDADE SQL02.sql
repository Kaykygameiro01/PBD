-- Criação da tabela DEPARTAMENTO sem restrições de integridade
CREATE TABLE DEPARTAMENTO (
    Nome VARCHAR2(50),
    Numero NUMBER(2) PRIMARY KEY,
    RG_Gerente NUMBER(8)
);

-- Criação da tabela EMPREGADO sem restrições de integridade
CREATE TABLE EMPREGADO (
    Nome VARCHAR2(50),
    RG NUMBER(8) PRIMARY KEY,
    CIC NUMBER(8) UNIQUE,
    Depto NUMBER(2),
    RG_Supervisor NUMBER(8),
    Salario NUMBER(10,2)
);

-- Criação da tabela PROJETO
CREATE TABLE PROJETO (
    Nome VARCHAR2(50),
    Numero NUMBER(2) PRIMARY KEY,
    Localizacao VARCHAR2(50)
);

-- Criação da tabela DEPENDENTES sem restrições de integridade
CREATE TABLE DEPENDENTES (
    RG_Responsavel NUMBER(8),
    Nome_Dependente VARCHAR2(50),
    Nascimento DATE,
    Relacao VARCHAR2(10),
    Sexo VARCHAR2(10)
);

-- Criação da tabela DEPARTAMENTO_PROJETO sem restrições de integridade
CREATE TABLE DEPARTAMENTO_PROJETO (
    Numero_Depto NUMBER(2),
    Numero_Projeto NUMBER(2),
    PRIMARY KEY (Numero_Depto, Numero_Projeto)
);

-- Criação da tabela EMPREGADO_PROJETO sem restrições de integridade
CREATE TABLE EMPREGADO_PROJETO (
    RG_Empregado NUMBER(8),
    Numero_Projeto NUMBER(2),
    Horas NUMBER(4),
    PRIMARY KEY (RG_Empregado, Numero_Projeto)
);

-- Inserção de dados na tabela DEPARTAMENTO
INSERT INTO DEPARTAMENTO VALUES ('Contabilidade', 1, 10101010);
INSERT INTO DEPARTAMENTO VALUES ('Engenharia Civil', 2, 30303030);
INSERT INTO DEPARTAMENTO VALUES ('Engenharia Mecânica', 3, 20202020);

-- Inserção de dados na tabela EMPREGADO
INSERT INTO EMPREGADO VALUES ('João Luiz', 10101010, 11111111, 1, NULL, 3000.00);
INSERT INTO EMPREGADO VALUES ('Fernando', 20202020, 22222222, 2, 10101010, 2500.00);
INSERT INTO EMPREGADO VALUES ('Ricardo', 30303030, 33333333, 2, 10101010, 2300.00);
INSERT INTO EMPREGADO VALUES ('Jorge', 40404040, 44444444, 2, 20202020, 4200.00);
INSERT INTO EMPREGADO VALUES ('Renato', 50505050, 55555555, 3, 20202020, 1300.00);

-- Inserção de dados na tabela PROJETO
INSERT INTO PROJETO VALUES ('Financeiro 1', 5, 'São Paulo');
INSERT INTO PROJETO VALUES ('Motor 3', 10, 'Rio Claro');
INSERT INTO PROJETO VALUES ('Prédio Central', 20, 'Campinas');

-- Inserção de dados na tabela DEPENDENTES
INSERT INTO DEPENDENTES VALUES (10101010, 'Jorge', TO_DATE('27/12/1986', 'DD/MM/YYYY'), 'Filho', 'Masculino');
INSERT INTO DEPENDENTES VALUES (10101010, 'Luiz', TO_DATE('18/11/1979', 'DD/MM/YYYY'), 'Filho', 'Masculino');
INSERT INTO DEPENDENTES VALUES (20202020, 'Fernanda', TO_DATE('14/02/1969', 'DD/MM/YYYY'), 'Cônjuge', 'Feminino');
INSERT INTO DEPENDENTES VALUES (20202020, 'Ângelo', TO_DATE('10/02/1995', 'DD/MM/YYYY'), 'Filho', 'Masculino');
INSERT INTO DEPENDENTES VALUES (30303030, 'Adreia', TO_DATE('01/05/1990', 'DD/MM/YYYY'), 'Filho', 'Feminino');

-- Inserção de dados na tabela DEPARTAMENTO_PROJETO
INSERT INTO DEPARTAMENTO_PROJETO VALUES (2, 5);
INSERT INTO DEPARTAMENTO_PROJETO VALUES (2, 10);
INSERT INTO DEPARTAMENTO_PROJETO VALUES (2, 20);

-- Inserção de dados na tabela EMPREGADO_PROJETO
INSERT INTO EMPREGADO_PROJETO VALUES (20202020, 5, 10);
INSERT INTO EMPREGADO_PROJETO VALUES (20202020, 10, 25);
INSERT INTO EMPREGADO_PROJETO VALUES (30303030, 5, 35);
INSERT INTO EMPREGADO_PROJETO VALUES (40404040, 20, 20);
INSERT INTO EMPREGADO_PROJETO VALUES (50505050, 20, 25);

-- Agora, adicionando as restrições de integridade referencial (chaves estrangeiras)

-- Adicionando a chave estrangeira na tabela EMPREGADO para DEPARTAMENTO
ALTER TABLE EMPREGADO
ADD CONSTRAINT FK_EMPREGADO_DEPARTAMENTO FOREIGN KEY (Depto)
REFERENCES DEPARTAMENTO(Numero);

-- Adicionando a chave estrangeira na tabela EMPREGADO para EMPREGADO (Supervisor)
ALTER TABLE EMPREGADO
ADD CONSTRAINT FK_EMPREGADO_SUPERVISOR FOREIGN KEY (RG_Supervisor)
REFERENCES EMPREGADO(RG);

-- Adicionando a chave estrangeira na tabela DEPENDENTES para EMPREGADO
ALTER TABLE DEPENDENTES
ADD CONSTRAINT FK_DEPENDENTES_RESPONSAVEL FOREIGN KEY (RG_Responsavel)
REFERENCES EMPREGADO(RG);

-- Adicionando a chave estrangeira na tabela DEPARTAMENTO para EMPREGADO (Gerente)
ALTER TABLE DEPARTAMENTO
ADD CONSTRAINT FK_DEPARTAMENTO_GERENTE FOREIGN KEY (RG_Gerente)
REFERENCES EMPREGADO(RG);

-- Adicionando a chave estrangeira na tabela DEPARTAMENTO_PROJETO para DEPARTAMENTO
ALTER TABLE DEPARTAMENTO_PROJETO
ADD CONSTRAINT FK_DEPARTAMENTO_PROJETO_DEPARTAMENTO FOREIGN KEY (Numero_Depto)
REFERENCES DEPARTAMENTO(Numero);

-- Adicionando a chave estrangeira na tabela DEPARTAMENTO_PROJETO para PROJETO
ALTER TABLE DEPARTAMENTO_PROJETO
ADD CONSTRAINT FK_DEPARTAMENTO_PROJETO_PROJETO FOREIGN KEY (Numero_Projeto)
REFERENCES PROJETO(Numero);

-- Adicionando a chave estrangeira na tabela EMPREGADO_PROJETO para EMPREGADO
ALTER TABLE EMPREGADO_PROJETO
ADD CONSTRAINT FK_EMPREGADO_PROJETO_EMPREGADO FOREIGN KEY (RG_Empregado)
REFERENCES EMPREGADO(RG);

-- Adicionando a chave estrangeira na tabela EMPREGADO_PROJETO para PROJETO
ALTER TABLE EMPREGADO_PROJETO
ADD CONSTRAINT FK_EMPREGADO_PROJETO_PROJETO FOREIGN KEY (Numero_Projeto)
REFERENCES PROJETO(Numero);


-- 1. Encontre os nomes de todos os empregados que trabalham para o departamento de Engenharia Civil.
SELECT E.Nome
FROM EMPREGADO E
JOIN DEPARTAMENTO D ON E.Depto = D.Numero
WHERE D.Nome = 'Engenharia Civil';

-- 2. Listar os números dos projetos, os números dos departamentos e o nome do gerente para projetos localizados em "São Paulo".
SELECT P.Numero AS Numero_Projeto, D.Numero AS Numero_Departamento, E.Nome AS Nome_Gerente
FROM PROJETO P
JOIN DEPARTAMENTO_PROJETO DP ON P.Numero = DP.Numero_Projeto
JOIN DEPARTAMENTO D ON DP.Numero_Depto = D.Numero
JOIN EMPREGADO E ON D.RG_Gerente = E.RG
WHERE P.Localizacao = 'São Paulo';

-- 3. Encontre os empregados que trabalham em todos os projetos controlados pelo departamento número 3.
SELECT E.Nome
FROM EMPREGADO E
JOIN EMPREGADO_PROJETO EP ON E.RG = EP.RG_Empregado
WHERE EP.Numero_Projeto IN (SELECT Numero_Projeto FROM DEPARTAMENTO_PROJETO WHERE Numero_Depto = 3)
GROUP BY E.Nome
HAVING COUNT(DISTINCT EP.Numero_Projeto) = (SELECT COUNT(DISTINCT Numero_Projeto) FROM DEPARTAMENTO_PROJETO WHERE Numero_Depto = 3);

-- 4. Liste os números dos projetos que envolvem um empregado chamado "Fernando" como trabalhador ou gerente do departamento que controla o projeto.
SELECT DISTINCT P.Numero
FROM PROJETO P
JOIN DEPARTAMENTO_PROJETO DP ON P.Numero = DP.Numero_Projeto
JOIN EMPREGADO_PROJETO EP ON P.Numero = EP.Numero_Projeto
JOIN EMPREGADO E ON EP.RG_Empregado = E.RG
WHERE E.Nome = 'Fernando'
OR DP.Numero_Depto IN (SELECT Numero FROM DEPARTAMENTO WHERE RG_Gerente = (SELECT RG FROM EMPREGADO WHERE Nome = 'Fernando'));

-- 5. Liste os nomes dos empregados que não possuem dependentes.
SELECT E.Nome
FROM EMPREGADO E
LEFT JOIN DEPENDENTES D ON E.RG = D.RG_Responsavel
WHERE D.Nome_Dependente IS NULL;

-- 6. Liste os nomes dos gerentes que têm pelo menos um dependente.
SELECT DISTINCT E.Nome
FROM EMPREGADO E
JOIN DEPENDENTES D ON E.RG = D.RG_Responsavel
JOIN DEPARTAMENTO DE ON E.RG = DE.RG_Gerente;

-- 7. Selecione o número do departamento que controla projetos localizados em Rio Claro.
SELECT DISTINCT DP.Numero_Depto
FROM DEPARTAMENTO_PROJETO DP
JOIN PROJETO P ON DP.Numero_Projeto = P.Numero
WHERE P.Localizacao = 'Rio Claro';

-- 8. Selecione o nome e o RG de todos os funcionários que são supervisores.
SELECT DISTINCT E.Nome, E.RG
FROM EMPREGADO E
WHERE E.RG IN (SELECT RG_Supervisor FROM EMPREGADO WHERE RG_Supervisor IS NOT NULL);

-- 9. Selecione todos os empregados com salário maior ou igual a 2000,00.
SELECT Nome
FROM EMPREGADO
WHERE Salario >= 2000.00;

-- 10. Selecione todos os empregados cujo nome começa com 'J'.
SELECT Nome
FROM EMPREGADO
WHERE Nome LIKE 'J%';

-- 11. Mostre todos os empregados que têm 'Luiz' ou 'Luis' no nome.
SELECT Nome
FROM EMPREGADO
WHERE Nome LIKE '%Luiz%' OR Nome LIKE '%Luis%';

-- 12. Mostre todos os empregados do departamento de 'Engenharia Civil'.
SELECT E.Nome
FROM EMPREGADO E
JOIN DEPARTAMENTO D ON E.Depto = D.Numero
WHERE D.Nome = 'Engenharia Civil';

-- 13. Mostre todos os nomes dos departamentos envolvidos com o projeto 'Motor 3'.
SELECT DISTINCT D.Nome
FROM DEPARTAMENTO D
JOIN DEPARTAMENTO_PROJETO DP ON D.Numero = DP.Numero_Depto
JOIN PROJETO P ON DP.Numero_Projeto = P.Numero
WHERE P.Nome = 'Motor 3';

-- 14. Liste o nome dos empregados envolvidos com o projeto 'Financeiro 1'.
SELECT DISTINCT E.Nome
FROM EMPREGADO E
JOIN EMPREGADO_PROJETO EP ON E.RG = EP.RG_Empregado
JOIN PROJETO P ON EP.Numero_Projeto = P.Numero
WHERE P.Nome = 'Financeiro 1';

-- 15. Mostre os funcionários cujo supervisor ganha entre 2000 e 2500.
SELECT E.Nome
FROM EMPREGADO E
JOIN EMPREGADO S ON E.RG_Supervisor = S.RG
WHERE S.Salario BETWEEN 2000 AND 2500;

-- 16. Liste o nome dos gerentes que têm ao menos um dependente.
SELECT DISTINCT E.Nome
FROM EMPREGADO E
JOIN DEPARTAMENTO D ON E.RG = D.RG_Gerente
JOIN DEPENDENTES DEP ON E.RG = DEP.RG_Responsavel;

-- 17. Atualize o salário de todos os empregados que trabalham no departamento 2 para R$ 3.000,00.
UPDATE EMPREGADO
SET Salario = 3000.00
WHERE Depto = 2;

-- 18. Aumentar o salário de todos os funcionários em 10%.
UPDATE EMPREGADO
SET Salario = Salario * 1.10;

-- 19. Mostre a média salarial dos empregados da empresa.
SELECT AVG(Salario) AS Media_Salarial
FROM EMPREGADO;

-- 20. Mostre os nomes dos empregados (em ordem alfabética) com salário maior que a média.
SELECT Nome
FROM EMPREGADO
WHERE Salario > (SELECT AVG(Salario) FROM EMPREGADO)
ORDER BY Nome;

