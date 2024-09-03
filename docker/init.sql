-- 1. Criação do banco de dados se não existir
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'bonsite_db') THEN
        PERFORM dblink_exec('dbname=postgres', 'CREATE DATABASE bonsite_db');
    END IF;
END $$;

-- 2. Conectar ao banco de dados
\c bonsite_db;

-- 3. Criação da tabela de categorias, se não existir
CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- 4. Criação da tabela de bonsais com JSONB para detalhes, se não existir
CREATE TABLE IF NOT EXISTS bonsais (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category_id INT REFERENCES categories(id),
    details JSONB
);

-- 5. Atualizações nas tabelas existentes (Exemplo: Adicionar colunas, modificar tipos)
DO $$ 
BEGIN
    -- Verifica se a coluna 'new_column' existe, se não, a adiciona como exemplo
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'bonsais' AND column_name = 'new_column') THEN
        ALTER TABLE bonsais ADD COLUMN new_column VARCHAR(100);
    END IF;
END $$;

-- 6. Inserção das categorias, se ainda não existirem
INSERT INTO categories (name) 
SELECT 'Frutíferas' WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Frutíferas');
INSERT INTO categories (name) 
SELECT 'Floríferas' WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Floríferas');
INSERT INTO categories (name) 
SELECT 'Perenes' WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Perenes');
INSERT INTO categories (name) 
SELECT 'Caducifólias' WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Caducifólias');

-- 7. Inserção de exemplo de bonsai com detalhes em JSONB, se ainda não existir
INSERT INTO bonsais (name, category_id, details) 
SELECT 'Bonsai de Jabuticaba', 1, 
'{
    "sun_exposure": "Sol pleno",
    "watering": "Moderada",
    "size": "Pequeno",
    "pruning": "Regular",
    "fertilization": "Mensal",
    "delicacy": "Alta"
}'
WHERE NOT EXISTS (SELECT 1 FROM bonsais WHERE name = 'Bonsai de Jabuticaba');

-- 8. Consultar os dados para verificar a inserção
SELECT * FROM bonsais;
