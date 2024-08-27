GO
IF NOT EXISTS(SELECT name FROM SYS.DATABASES WHERE [name] = 'Foodie_DB')
BEGIN
    CREATE DATABASE Foodie_DB COLLATE Latin1_general_CI_AI;
END

GO
USE Foodie_DB

PRINT('-------------- START OF STRUCTURE SCRIPT --------------')

PRINT('-------------- CREATING TABLES --------------')

GO

IF OBJECT_ID('users') IS NULL
BEGIN
    CREATE TABLE users (
        Id UNIQUEIDENTIFIER PRIMARY KEY,
        Avatar NVARCHAR(150) DEFAULT 'default.png' NOT NULL,
        Name NVARCHAR(200) NOT NULL,
        Phone VARCHAR(12) NOT NULL UNIQUE,
        Email VARCHAR(100) NOT NULL UNIQUE,
        CPF VARCHAR(69) NOT NULL UNIQUE,
        Created_At DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        Updated_At DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
    )
END

GO
IF OBJECT_ID('user_addresses') IS NULL
BEGIN
    CREATE TABLE user_addresses (
        Id UNIQUEIDENTIFIER PRIMARY KEY,
        [User_Id] UNIQUEIDENTIFIER NOT NULL,
        [Address] NVARCHAR(300) NOT NULL,
        [Number] VARCHAR(10),
        Address_Complement VARCHAR(50),
        Is_Default BIT NOT NULL DEFAULT 0,
        Created_At DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        Updated_At DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        CONSTRAINT FK_USER_USER_ADDRESS FOREIGN KEY ([User_Id]) REFERENCES users(Id)
    )
END

GO
IF OBJECT_ID('store_types') IS NULL
BEGIN
    CREATE TABLE store_types (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        Name VARCHAR(50) NOT NULL,
        Avatar NVARCHAR(MAX),
        Created_At DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        Updated_At DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
    )
END

GO
IF OBJECT_ID('stores') IS NULL
BEGIN
    CREATE TABLE stores (
        Id UNIQUEIDENTIFIER PRIMARY KEY,
        Name NVARCHAR(150) NOT NULL,
        Avatar NVARCHAR(150) DEFAULT 'default.png',
        Store_Type_Id INT NOT NULL,
        [Description] NVARCHAR(MAX),
        Order_Min_Value DECIMAL(7,2),
        Open_At TIME NOT NULL,
        Closed_At TIME NOT NULL,
        [Address] NVARCHAR(1000) NOT NULL,
        CNPJ VARCHAR(16) NOT NULL,
        CEP VARCHAR(8) NOT NULL,
        Store_Min_Delivery_Time VARCHAR(3) NOT NULL,
	Store_Max_Delivery_Time VARCHAR(3) NOT NULL,
	Store_Delivery_Fee DECIMAL(4,2) DEFAULT 0.00,
	Store_Rate DECIMAL(2,1) DEFAULT 0.0,
        Created_At DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        Updated_At DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        CONSTRAINT FK_STORE_STORE_TYPE_ID FOREIGN KEY (Store_Type_Id) REFERENCES store_types(Id)
    )
END

GO
IF OBJECT_ID('payment_options') IS NULL
BEGIN
    CREATE TABLE payment_options (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Option_name VARCHAR(50) NOT NULL,
    )
END

GO
IF OBJECT_ID('stores_categories') IS NULL
BEGIN
    CREATE TABLE stores_categories (
        Id UNIQUEIDENTIFIER PRIMARY KEY,
        Title VARCHAR(30) NOT NULL,
        Store_Id UNIQUEIDENTIFIER NOT NULL,
        CONSTRAINT FK_STORECATEGORY_STORE FOREIGN KEY (Store_Id) REFERENCES stores(Id),
    )
END


GO
IF OBJECT_ID('products') IS NULL
BEGIN
    CREATE TABLE products (
        Id UNIQUEIDENTIFIER PRIMARY KEY,
        Name VARCHAR(150) NOT NULL,
        [Value] DECIMAL(7,2) NOT NULL,
        Store_Id UNIQUEIDENTIFIER NOT NULL,
        [Description] VARCHAR(300) NOT NULL,
        Store_Category_Id UNIQUEIDENTIFIER NOT NULL,
        [Weight] VARCHAR(8),
        People_Served INT,
        Avatar nvarchar(150) DEFAULT 'default_product.png',
        Created_At DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        Updated_At DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        CONSTRAINT FK_PRODUCT_STORE FOREIGN KEY (Store_Id) REFERENCES stores(Id),
        CONSTRAINT FK_PRODUCT_STORECATEGORY FOREIGN KEY (Store_Category_Id) REFERENCES stores_categories(Id)
    )
END


GO
IF OBJECT_ID('carts') IS NULL
BEGIN
    CREATE TABLE carts (
        Id UNIQUEIDENTIFIER PRIMARY KEY,
        Product_Id UNIQUEIDENTIFIER NOT NULL,
        [User_Id] UNIQUEIDENTIFIER NOT NULL,
        Product_Amount INT NOT NULL,
        Created_At DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        Updated_At DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        CONSTRAINT FK_CARTS_USERS FOREIGN KEY ([User_Id]) REFERENCES users(Id),
        CONSTRAINT FK_CARTS_PRODUCT FOREIGN KEY (Product_Id) REFERENCES products(Id),
    )
END



GO
IF OBJECT_ID('orders') IS NULL
BEGIN
    CREATE TABLE orders (
        Id UNIQUEIDENTIFIER PRIMARY KEY,
        [User_Id] UNIQUEIDENTIFIER NOT NULL,
        Cart_Id UNIQUEIDENTIFIER NOT NULL,
        Paid_At DATETIME,
        Completed_At DATETIME,
        Paid_By_Id INT NOT NULL,
        SubTotal_Value DECIMAL(7,2) NOT NULL,
        Delivery_Fee_Value DECIMAL(7,2) NOT NULL,
        Total_Value DECIMAL(7,2) NOT NULL,
        User_Address_Id UNIQUEIDENTIFIER NOT NULL,
        Created_At DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        Updated_At DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        CONSTRAINT FK_ORDERS_USERS FOREIGN KEY ([User_Id]) REFERENCES users(Id),
        CONSTRAINT FK_ORDERS_CART FOREIGN KEY (Cart_Id) REFERENCES carts(Id),
        CONSTRAINT FK_ORDERS_PAIDBY FOREIGN KEY (Paid_By_Id) REFERENCES payment_options(Id),
    )
END

GO
IF OBJECT_ID('store_rates') IS NULL
BEGIN
    CREATE TABLE store_rates (
        Id UNIQUEIDENTIFIER PRIMARY KEY,
        Store_Id UNIQUEIDENTIFIER NOT NULL,
        Order_Id UNIQUEIDENTIFIER NOT NULL,
        Stars_Number INT NOT NULL,
        [Description] NVARCHAR(350),
        Created_At DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        Updated_At DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        CONSTRAINT FK_STORERATE_STORE FOREIGN KEY (Store_Id) REFERENCES stores(Id),
        CONSTRAINT FK_STORERATE_ORDERS FOREIGN KEY (Order_Id) REFERENCES orders(Id)
    )
END


PRINT('-------------- CREATING INDEXES --------------')

IF (SELECT COUNT(1) FROM sys.indexes WHERE object_id = OBJECT_ID('stores') AND name like 'IDX_%') = 0
BEGIN
  CREATE NONCLUSTERED INDEX IDX_STORE_NAME ON stores([Name])
  CREATE NONCLUSTERED INDEX IDX_STORE_CNPJ ON stores(CNPJ)
END

IF (SELECT COUNT(1) FROM sys.indexes WHERE object_id = OBJECT_ID('stores_categories') AND name like 'IDX_%') = 0
BEGIN
CREATE NONCLUSTERED INDEX IDX_STORECATEGORIES_TITLE ON stores_categories(Title)
CREATE NONCLUSTERED INDEX IDX_STORECATEGORIES_STOREID ON stores_categories(Store_Id)
END

IF (SELECT COUNT(1) FROM sys.indexes WHERE object_id = OBJECT_ID('carts') AND name like 'IDX_%') = 0
BEGIN
CREATE NONCLUSTERED INDEX IDX_CARTS_PRODUCTID ON carts(Product_Id)
CREATE NONCLUSTERED INDEX IDX_CARTS_USERID ON carts([User_id])
END

IF (SELECT COUNT(1) FROM sys.indexes WHERE object_id = OBJECT_ID('orders') AND name like 'IDX_%') = 0
BEGIN
  CREATE NONCLUSTERED INDEX IDX_ORDERS_USERID ON orders([User_id])
  CREATE NONCLUSTERED INDEX IDX_ORDERS_CARTID ON orders(Cart_id)
END

IF (SELECT COUNT(1) FROM sys.indexes WHERE object_id = OBJECT_ID('store_rates') AND name like 'IDX_%') = 0
BEGIN
  CREATE NONCLUSTERED INDEX IDX_STORERATES_STOREID ON store_rates(Store_Id)
  CREATE NONCLUSTERED INDEX IDX_STORERATES_ORDERID ON store_rates(Order_Id)
END

PRINT('-------------- INSERTING DATA --------------')
IF NOT EXISTS(SELECT TOP 1 1
              FROM store_types)
BEGIN
PRINT('-------------- INSERTING STORE TYPES --------------')
insert into store_types (Name, Avatar, Created_At, Updated_At)
values
	('Lanches', 'https://static.ifood-static.com.br/image/upload/t_medium/discoveries/lanches_HC15.png?imwidth=256',CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('Chinesa', 'https://static.ifood-static.com.br/image/upload/t_medium/discoveries/chinesa_cc11.png?imwidth=256', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('Italiana', 'https://static.ifood-static.com.br/image/upload/t_medium/discoveries/italiana_qyJW.png?imwidth=256', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('Japonesa', 'https://static.ifood-static.com.br/image/upload/t_medium/discoveries/japonesa_FP14.png?imwidth=256', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('Mexicana', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('Sopas e Caldos', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('Vegetariana', 'https://static.ifood-static.com.br/image/upload/t_medium/discoveries/vegetariana_XGvO.png?imwidth=256', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('Frutos do Mar', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('Árabe', 'https://static.ifood-static.com.br/image/upload/t_medium/discoveries/arabe_PbzV.png?imwidth=256', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('Brasileira', 'https://static.ifood-static.com.br/image/upload/t_medium/discoveries/brasileira1XfT_5HRd.png?imwidth=256', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('Padarias', 'https://static.ifood-static.com.br/image/upload/t_medium/discoveries/padarias_O8Ek.png?imwidth=256', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF NOT EXISTS(SELECT TOP 1 1
              FROM stores)
BEGIN
PRINT('-------------- INSERTING STORES --------------')
insert into stores (
    Id, Name, Avatar, Store_Type_Id, Description, Order_Min_Value, Open_At, Closed_At, Address, CNPJ, CEP, Store_Rate, Store_Delivery_Fee, Store_Min_Delivery_Time, Store_Max_Delivery_Time
) values
      (newid(), 'McDonald''s', 'https://seeklogo.com/images/M/mcdonald-s-logo-255A7B5646-seeklogo.com.png', 1, 'A Arcos Dorados é a maior franquia independente direitos exclusivos de possuir, operar e conceder o McDonald’s do mundo e a principal rede de alimentação rápida em toda América Latina e Caribe. A companhia tem as franquias de restaurantes McDonald''s em 20 países e territórios, incluindo Argentina, Aruba, Brasil, Chile, Colômbia, Costa Rica, Curaçao, Equador, Guiana Francesa, Guadalupe, Martinica, México, Panamá, Peru, Porto Rico, St. Croix, St. Thomas, Trinidad & Tobago, Uruguai e Venezuela.', 15.00, CONVERT(TIME, '12:00 PM'), CONVERT(TIME, '02:00 AM'), 'Rua 36, 36 Norte', '00000000/0000-00','12345678', 0.0, 0.00, '30', '50'),
      (newid(), 'China in Box', 'https://seeklogo.com/images/C/china-in-box-logo-D1BF9CC471-seeklogo.com.png', 2, 'É uma rede de fast-food de comida chinesa, inaugurada em 1992 no bairro paulistano de Moema por Robinson Shiba e presente em várias cidades do Brasil, com 145 lojas.', 15, CONVERT(TIME, '12:00 PM'), CONVERT(TIME, '21:45 PM'), 'R. 9 Norte, lote 6/8 loja, 01', '1958765325416532', '71953970', 0.0, 0.00, '30', '50'),
      (newid(), 'Burger King', 'https://seeklogo.com/images/B/burger-king-new-2021-logo-F43BDE45C7-seeklogo.com.png', 1, 'É uma rede de restaurantes especializada em fast-food, fundada nos Estados Unidos por James McLamore e David Edgerton, que abriram a primeira unidade em Miami, Flórida.', 20, CONVERT(TIME, '12:00 PM'), CONVERT(TIME, '04:00 AM'), 'St. A Sul QSA 3/5 PPL, Área Especial 1 s/n', '1958765325416532', '72015034', 0.0, 0.00, '30', '50'),
      (newid(), 'La Mole', 'https://seeklogo.com/images/R/Restaurante_La_Mole-logo-F9485B7327-seeklogo.com.gif', 3, 'Clássico restaurante italiano inaugurado no Estado do Rio de Janeiro, famoso por seus pratos clássicos agora com poucos cliques direto para sua casa.', 20, CONVERT(TIME, '12:00 PM'), CONVERT(TIME, '00:00 AM'), 'R. Dias da Rocha, 31 - loja B', '1958765325416532', '22051020', 0.0, 0.00, '30', '50'),
      (newid(), 'Taco Bell', 'https://seeklogo.com/images/T/taco-bell-logo-E3BE785EC0-seeklogo.com.png', 5, 'É uma cadeia estadunidense de restaurantes de fast-food, inspirada pela culinária mexicana e fundada por Glen Bell', 15, CONVERT(TIME, '12:00 PM'), CONVERT(TIME, '02:00 AM'), 'Av. Pastor Martin Luther King Jr., 126', '1958765325416532', '20765630', 0.0, 0.00, '30', '50'),
      (newid(), 'Koni Japa', 'https://static.ifood-static.com.br/image/upload/t_high/logosgde/19651995-9e84-4618-b87a-9367502e8873/202203081441_z1Oq_i.jpg', 4, 'É uma rede de franquias de restaurantes fast-food do Brasil que serve pratos e comidas da culinária japonesa, notoriamente variedades de temakis, sashimis e yakissoba.', 20, CONVERT(TIME, '12:00 PM'), CONVERT(TIME, '01:00 AM'), 'Asa Sul Comércio Local Sul 209 BL B', '1958765325416532', '70272520', 0.0, 0.00, '30', '50')
END

IF NOT EXISTS(SELECT TOP 1 1
              FROM stores_categories)
BEGIN
PRINT('-------------- INSERTING STORE CATEGORIES --------------')
insert into stores_categories (Id, Title, Store_Id)
values
    (newid(), 'Promoções', (select Id from stores where Name = 'McDonald''s')),
    (newid(), 'Sanduíches', (select Id from stores where Name = 'McDonald''s')),
    (newid(), 'Acompanhamentos', (select Id from stores where Name = 'McDonald''s')),
    (newid(), 'Sobremesas', (select Id from stores where Name = 'McDonald''s')),
    (newid(), 'Bebidas', (select Id from stores where Name = 'McDonald''s')),
    (newid(), 'Favoritos', (select Id from stores where Name = 'Burger King')),
    (newid(), 'Whoppers Especiais', (select Id from stores where Name = 'Burger King')),
    (newid(), 'Acompanhamentos', (select Id from stores where Name = 'Burger King')),
    (newid(), 'Bebidas', (select Id from stores where Name = 'Burger King')),
    (newid(), 'Pokes', (select Id from stores where Name = 'Koni Japa')),
    (newid(), 'Temakis', (select Id from stores where Name = 'Koni Japa')),
    (newid(), 'Rolls', (select Id from stores where Name = 'Koni Japa')),
    (newid(), 'Sushis e Sashimis', (select Id from stores where Name = 'Koni Japa')),
    (newid(), 'Combinados', (select Id from stores where Name = 'Koni Japa'))
END

IF NOT EXISTS(SELECT TOP 1 1
              FROM products)
BEGIN
PRINT('-------------- INSERTING PRODUCTS CATEGORIES --------------')
insert into products (Id, Name, Value, Store_Id, Description, Store_Category_Id, Weight, People_Served, Avatar)
values
    (
        newid(),
        'Big Mac',
        29.90,
        (select Id from stores where name = 'McDonald''s'),
        'Dois hambúrgueres (100% carne bovina), alface americana, queijo cheddar, maionese Big Mac, cebola, picles e pão com gergelim',
        (select Id from stores_categories where Title = 'Sanduíches' and Store_Id = (select Id from stores where Name = 'McDonald''s')),
        NULL,
        NULL,
        'https://static.ifood-static.com.br/image/upload/t_low/pratos/f1613b9f-7a5f-49c4-9687-2a3798c26092/202406180422_1lkhqtbmex5.png'
    ),
    (
        newid(),
        'Quarterão Com Queijo',
        28.90,
        (select Id from stores where name = 'McDonald''s'),
        'Um hambúrguer (100% carne bovina), queijo cheddar, picles, cebola, ketchup, mostarda e pão com gergelim',
        (select Id from stores_categories where Title = 'Sanduíches' and Store_Id = (select Id from stores where Name = 'McDonald''s')),
        NULL,
        NULL,
        'https://static.ifood-static.com.br/image/upload/t_low/pratos/f1613b9f-7a5f-49c4-9687-2a3798c26092/202406180423_2rz36omws9h.png'
   ),
    (
        newid(),
        'Cheddar McMelt',
        29.90,
        (select Id from stores where name = 'McDonald''s'),
        'Um hambúrguer (100% carne bovina), molho lácteo com queijo tipo cheddar, cebola ao molho shoyu e pão escuro com gergelim',
        (select Id from stores_categories where Title = 'Sanduíches' and Store_Id = (select Id from stores where Name = 'McDonald''s')),
        NULL,
        NULL,
        'https://static.ifood-static.com.br/image/upload/t_low/pratos/f1613b9f-7a5f-49c4-9687-2a3798c26092/202406260428_8szllyalux6.png'
   ),
    (
        newid(),
        'McChicken',
        27.90,
        (select Id from stores where name = 'McDonald''s'),
        'Frango empanado, maionese, alface americana e pão com gergelim',
        (select Id from stores_categories where Title = 'Sanduíches' and Store_Id = (select Id from stores where Name = 'McDonald''s')),
        NULL,
        NULL,
        'https://static.ifood-static.com.br/image/upload/t_low/pratos/f1613b9f-7a5f-49c4-9687-2a3798c26092/202406180423_n1qazfp2gg9.png'
   ),
    (
        newid(),
        'McFritas Cheddar Bacon',
        20.90,
        (select Id from stores where name = 'McDonald''s'),
        'A batata frita mais famosa do mundo, agora com molho com queijo tipo cheddar e bacon crispy. Não dá para resistir, experimente!',
        (select Id from stores_categories where Title = 'Acompanhamentos' and Store_Id = (select Id from stores where Name = 'McDonald''s')),
        NULL,
        NULL,
        'https://static.ifood-static.com.br/image/upload/t_low/pratos/f1613b9f-7a5f-49c4-9687-2a3798c26092/202406180423_n1qazfp2gg9.png'
   ),
    (
        newid(),
        'McFritas Grande',
        27.90,
        (select Id from stores where name = 'McDonald''s'),
        'Deliciosas batatas selecionadas, fritas, crocantes por fora, macias por dentro, douradas, irresistíveis, saborosas, famosas, e todos os outros adjetivos positivos que você quiser dar',
        (select Id from stores_categories where Title = 'Acompanhamentos' and Store_Id = (select Id from stores where Name = 'McDonald''s')),
        NULL,
        NULL,
        'https://static.ifood-static.com.br/image/upload/t_low/pratos/f1613b9f-7a5f-49c4-9687-2a3798c26092/202406180423_ngukgmyczvd.png'
   ),
    (
        newid(),
        'McFritas Média',
        27.90,
        (select Id from stores where name = 'McDonald''s'),
        'Deliciosas batatas selecionadas, fritas, crocantes por fora, macias por dentro, douradas, irresistíveis, saborosas, famosas, e todos os outros adjetivos positivos que você quiser dar',
        (select Id from stores_categories where Title = 'Acompanhamentos' and Store_Id = (select Id from stores where Name = 'McDonald''s')),
        NULL,
        NULL,
        'https://static.ifood-static.com.br/image/upload/t_low/pratos/f1613b9f-7a5f-49c4-9687-2a3798c26092/202406180423_svr1w9rakl.png'
   ),
        (
        newid(),
        'McFritas Pequena',
        27.90,
        (select Id from stores where name = 'McDonald''s'),
        'Deliciosas batatas selecionadas, fritas, crocantes por fora, macias por dentro, douradas, irresistíveis, saborosas, famosas, e todos os outros adjetivos positivos que você quiser dar',
        (select Id from stores_categories where Title = 'Acompanhamentos' and Store_Id = (select Id from stores where Name = 'McDonald''s')),
        NULL,
        NULL,
        'https://static.ifood-static.com.br/image/upload/t_low/pratos/f1613b9f-7a5f-49c4-9687-2a3798c26092/202406180423_vpygltkllj.png'
   ),
        (
        newid(),
        'Chicken McNuggets 15 unidades',
        27.90,
        (select Id from stores where name = 'McDonald''s'),
        'Crocantes, leves e deliciosos. Os frangos empanados mais irresistíveis do Mcdonald’s agora na versão Mega, ideal para compartilhar. Composto por 15 unidades de Chicken McNuggets',
        (select Id from stores_categories where Title = 'Acompanhamentos' and Store_Id = (select Id from stores where Name = 'McDonald''s')),
        NULL,
        NULL,
        'https://static.ifood-static.com.br/image/upload/t_low/pratos/f1613b9f-7a5f-49c4-9687-2a3798c26092/202406180423_ul87qvwq4fr.png'
   ),
        (
        newid(),
        'Coca-Cola 500ml',
        12.90,
        (select Id from stores where name = 'McDonald''s'),
        'Bebida gelada na medida certa para matar sua sede. Refrescante Coca-Cola 500ml',
        (select Id from stores_categories where Title = 'Bebidas' and Store_Id = (select Id from stores where Name = 'McDonald''s')),
        NULL,
        NULL,
        'https://static.ifood-static.com.br/image/upload/t_low/pratos/f1613b9f-7a5f-49c4-9687-2a3798c26092/202406260429_33ol9h9496q.png'
   ),
        (
        newid(),
        'Fanta Guaraná 500ml',
        12.90,
        (select Id from stores where name = 'McDonald''s'),
        'Bebida gelada na medida certa para matar sua sede. Refrescante Fanta Guaraná 500ml',
        (select Id from stores_categories where Title = 'Bebidas' and Store_Id = (select Id from stores where Name = 'McDonald''s')),
        NULL,
        NULL,
        'https://static.ifood-static.com.br/image/upload/t_low/pratos/f1613b9f-7a5f-49c4-9687-2a3798c26092/202406180423_ddngtiptyus.png'
   ),
        (
        newid(),
        'Sprite Sem Açúcar 500ml',
        12.90,
        (select Id from stores where name = 'McDonald''s'),
        'Bebida gelada na medida certa para matar sua sede. Refrescante Sprite Sem Açúcar 500ml',
        (select Id from stores_categories where Title = 'Bebidas' and Store_Id = (select Id from stores where Name = 'McDonald''s')),
        NULL,
        NULL,
        'https://static.ifood-static.com.br/image/upload/t_low/pratos/f1613b9f-7a5f-49c4-9687-2a3798c26092/202406180423_nmce2201iuk.png'
   ),
        (
        newid(),
        'McShake Ovomaltine 400ml',
        12.90,
        (select Id from stores where name = 'McDonald''s'),
        'O novo McShake é feito com leite e batido na hora com o delicioso Ovomaltine',
        (select Id from stores_categories where Title = 'Bebidas' and Store_Id = (select Id from stores where Name = 'McDonald''s')),
        NULL,
        NULL,
        'https://static.ifood-static.com.br/image/upload/t_low/pratos/f1613b9f-7a5f-49c4-9687-2a3798c26092/202406180423_r39as9fnhl.png'
   ),
        (
        newid(),
        'McShake Chocolate 400ml',
        12.90,
        (select Id from stores where name = 'McDonald''s'),
        'O novo McShake é feito com leite e batido na hora com o delicioso chocolate Kopenhagen',
        (select Id from stores_categories where Title = 'Bebidas' and Store_Id = (select Id from stores where Name = 'McDonald''s')),
        NULL,
        NULL,
        'https://static.ifood-static.com.br/image/upload/t_low/pratos/f1613b9f-7a5f-49c4-9687-2a3798c26092/202406180423_qut3xbz172.png'
   )
END

PRINT('-------------- FINISH OF STRUCTURE SCRIPT --------------')

