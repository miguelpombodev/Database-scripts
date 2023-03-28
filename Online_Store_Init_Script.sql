-- GO
-- CREATE DATABASE OnlineStore COLLATE Latin1_general_CI_AI;

USE OnlineStore
  
  --====================== CREATING TABLES ===========================

  PRINT('CREATING TABLES')

  GO
    IF OBJECT_ID('product_type') IS NULL 
      BEGIN

      CREATE TABLE product_type (
        id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        description NVARCHAR(50) NOT NULL,
        name NVARCHAR(40) NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
      )

      END

  GO
    IF OBJECT_ID('product_brand') IS NULL 
      BEGIN

      CREATE TABLE product_brand (
        id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        name NVARCHAR(25) NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
      )

      END

  GO
    IF OBJECT_ID('customers') IS NULL 
      BEGIN

      CREATE TABLE customers (
        id UNIQUEIDENTIFIER PRIMARY KEY,
        name NVARCHAR(15) NOT NULL,
        surname NVARCHAR(100) NOT NULL,
        CPF CHAR(11) NOT NULL,
        email NVARCHAR(255) NOT NULL,
        password NVARCHAR(64) NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
      )

      END

  GO
    IF OBJECT_ID('products') IS NULL 
      BEGIN

      CREATE TABLE products (
        id UNIQUEIDENTIFIER PRIMARY KEY,
        type_id INT NOT NULL,
        brand_id INT NOT NULL,
        sku VARCHAR(255) NOT NULL,
        name NVARCHAR(255) NOT NULL,
        value DECIMAL(6,2) NOT NULL,
        stock_amount INT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
        CONSTRAINT FK_PROD_PRODTYPE FOREIGN KEY (type_id) REFERENCES product_type(id),
        CONSTRAINT FK_PROD_BRANDID FOREIGN KEY (brand_id) REFERENCES product_brand(id)
      )

      END

  GO
    IF OBJECT_ID('product_colors') IS NULL 
      BEGIN

      CREATE TABLE product_colors (
        id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        product_id UNIQUEIDENTIFIER NOT NULL,
        name VARCHAR(25) NOT NULL,
        product_color_URL NVARCHAR(200) NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
        CONSTRAINT FK_PRODCOLOR_PROD FOREIGN KEY (product_id) REFERENCES products(id)
      )

      END

  GO
    IF OBJECT_ID('carts') IS NULL 
      BEGIN

      CREATE TABLE carts (
        id uniqueidentifier NOT NULL PRIMARY KEY,
        customer_id uniqueidentifier NOT NULL,
        purchased bit NOT NULL
        CONSTRAINT FK_CARTS_CUSTOMERS FOREIGN KEY (customer_id) REFERENCES customers(id)
      )

      END


  GO
    IF OBJECT_ID('cart_items') IS NULL 
      BEGIN

      CREATE TABLE cart_items (
        id uniqueidentifier NOT NULL,
        customer_id uniqueidentifier NOT NULL,
        cart_id uniqueidentifier NOT NULL,
        product_id uniqueidentifier NOT NULL,
        item_quantity int NOT NULL
        CONSTRAINT FK_CARTITEMS_CUSTOMERS FOREIGN KEY (customer_id) REFERENCES customers(id),
        CONSTRAINT FK_CARTITEMS_CART FOREIGN KEY (cart_id) REFERENCES carts(id)
      )

      END

  --====================== CREATING NON CLUSTERED INDEXES ===========================

--   GO
--   CREATE NONCLUSTERED INDEX IX_CUSTOMERS_CPF ON customers(CPF)
--   CREATE NONCLUSTERED INDEX IX_CUSTOMERS_EMAIL ON customers(email)
--   CREATE NONCLUSTERED INDEX IX_PRODUCTS_SKU ON products(sku)


  --====================== CREATING TABLES TRIGGERS ==========================
PRINT('CREATING TABLES TRIGGERS')

GO
IF NOT EXISTS (SELECT 1 FROM SYS.TRIGGERS WHERE NAME = 'TRG_UPDATE_UPDATEDAT_PRDCL_COLLUMN')
BEGIN
  EXEC('CREATE TRIGGER TRG_UPDATE_UPDATEDAT_PRDCL_COLLUMN ON product_colors AFTER UPDATE AS
    BEGIN
      IF NOT UPDATE(updated_at)
        BEGIN
          UPDATE t
          SET t.updated_at = CURRENT_TIMESTAMP
          FROM product_colors AS t
          inner join inserted as i
          on t.id = i.id
        END
    END') 
END

GO
IF NOT EXISTS (SELECT 1 FROM SYS.TRIGGERS WHERE NAME = 'TRG_UPDATE_UPDATEDAT_PRDTP_COLLUMN')
BEGIN
  EXEC('CREATE TRIGGER TRG_UPDATE_UPDATEDAT_PRDTP_COLLUMN ON product_type AFTER UPDATE AS
    BEGIN
      IF NOT UPDATE(updated_at)
        BEGIN
          UPDATE t
          SET t.updated_at = CURRENT_TIMESTAMP
          FROM product_type AS t
          inner join inserted as i
          on t.id = i.id
        END
    END') 
END


GO
IF NOT EXISTS (SELECT 1 FROM SYS.TRIGGERS WHERE NAME = 'TRG_UPDATE_UPDATEDAT_PRDBRD_COLLUMN')
  BEGIN
  EXEC('CREATE TRIGGER TRG_UPDATE_UPDATEDAT_PRDBRD_COLLUMN ON product_brand AFTER UPDATE AS
    BEGIN
      IF NOT UPDATE(updated_at)
        BEGIN
          UPDATE t
          SET t.updated_at = CURRENT_TIMESTAMP
          FROM product_brand AS t
          inner join inserted as i
          on t.id = i.id
        END
    END') 
END


 GO
 IF NOT EXISTS (SELECT 1 FROM SYS.TRIGGERS WHERE NAME = 'TRG_UPDATE_UPDATEDAT_CST_COLLUMN')
  BEGIN
  EXEC('CREATE TRIGGER TRG_UPDATE_UPDATEDAT_CST_COLLUMN ON customers AFTER UPDATE AS
    BEGIN
      IF NOT UPDATE(updated_at)
        BEGIN
          UPDATE t
          SET t.updated_at = CURRENT_TIMESTAMP
          FROM customers AS t
          inner join inserted as i
          on t.id = i.id
        END
    END')
  END


  GO
  IF NOT EXISTS (SELECT 1 FROM SYS.TRIGGERS WHERE NAME = 'TRG_UPDATE_UPDATEDAT_PRD_COLLUMN')
  BEGIN
  EXEC('CREATE TRIGGER TRG_UPDATE_UPDATEDAT_PRD_COLLUMN ON products AFTER UPDATE AS
    BEGIN
      IF NOT UPDATE(updated_at)
        BEGIN
          UPDATE t
          SET t.updated_at = CURRENT_TIMESTAMP
          FROM products AS t
          inner join inserted as i
          on t.id = i.id
        END
    END') 
END

  --====================== INSERTING DATA IN TABLES ==========================

  PRINT('INSERTING DATA IN TABLES')

GO
IF (SELECT COUNT(1) FROM product_type) = 0
    BEGIN

        INSERT INTO product_type VALUES('dolor sit amet consectetuer adipiscing','Tênis Masculino',GETDATE(),GETDATE())
        INSERT INTO product_type VALUES('venenatis tristique fusce congue','Camisa Masculina',GETDATE(),GETDATE())
        INSERT INTO product_type VALUES('ultrices libero non mattis','Camisa Feminina',GETDATE(),GETDATE())
        INSERT INTO product_type VALUES('eleifend quam a odio in','Calça Masculina',GETDATE(),GETDATE())
        INSERT INTO product_type VALUES('a libero nam dui proin leo','Calça Feminina',GETDATE(),GETDATE())
        INSERT INTO product_type VALUES('ultrices libero non mattis','Tênis Feminino',GETDATE(),GETDATE())
        INSERT INTO product_type VALUES('dolor sit amet consectetuer adipiscing','Bermuda Masculino',GETDATE(),GETDATE())
        INSERT INTO product_type VALUES('venenatis tristique fusce congue','Bermuda Feminina',GETDATE(),GETDATE())
        INSERT INTO product_type VALUES('ultrices libero non mattis','Casaco Feminino',GETDATE(),GETDATE())
        INSERT INTO product_type VALUES('eleifend quam a odio in','Casaco Masculino',GETDATE(),GETDATE())
        INSERT INTO product_type VALUES('a libero nam dui proin leo','Camisa de Time Feminina',GETDATE(),GETDATE())
        INSERT INTO product_type VALUES('ultrices libero non mattis','Camisa de Time Masculino',GETDATE(),GETDATE())

    END


GO
    IF (SELECT COUNT(1) FROM product_brand) = 0
        BEGIN
            INSERT INTO product_brand VALUES('Adidas',GETDATE(),GETDATE())
            INSERT INTO product_brand VALUES('Nike',GETDATE(),GETDATE())
            INSERT INTO product_brand VALUES('Puma',GETDATE(),GETDATE())
            INSERT INTO product_brand VALUES('Olympikus',GETDATE(),GETDATE())
            INSERT INTO product_brand VALUES('Mizuno',GETDATE(),GETDATE())
            INSERT INTO product_brand VALUES('Oakley',GETDATE(),GETDATE())
            INSERT INTO product_brand VALUES('Industrie',GETDATE(),GETDATE())
        END


IF (SELECT COUNT(1) FROM products) = 0
    BEGIN
        INSERT INTO products VALUES('EFD81AF5-846F-40AA-A6E7-1528D07E5DDD',1,1,'PRDTESTE01','Tênis Adidas Runfalcon 2.0 Masculino',239.00,222,GETDATE(),GETDATE())
        INSERT INTO products VALUES('152744BB-D67E-43B0-AEED-3054B644E8EB',1,2,'PRDTESTE01','Tênis Nike Revolution 5 Masculino',239.00,222,GETDATE(),GETDATE())
        INSERT INTO products VALUES('DFA69DEF-77AA-4B66-876F-33CF04BC543F',2,7,'PRDTESTE01','Camiseta Industrie NYC Masculina',239.00,222,GETDATE(),GETDATE())
        INSERT INTO products VALUES('2C186CA7-D8D6-46BD-9103-3BB900E61B66',1,2,'TSTPRDSKU','Tenis Nike SB Chron Solarsoft',88.64,257,GETDATE(),GETDATE())
        INSERT INTO products VALUES('BAC24716-DAB7-4A74-A735-829A9C3A9063',2,7,'TSTPRDSKU','Camiseta Ecko Estampada K163A Masculina',61.16,439,GETDATE(),GETDATE())
        INSERT INTO products VALUES('46CCF84D-7D22-4891-BB41-B1B5D78DE545',1,1,'PRDTESTE01','Shorts Tennis Club Adidas',239.00,222,GETDATE(),GETDATE())
        INSERT INTO products VALUES('B76E2151-24F3-4B39-BF6B-BAD0E786B38B',1,1,'PRDTESTE01','Tênis Adidas Breaknet Masculino',239.00,222,GETDATE(),GETDATE())
        INSERT INTO products VALUES('3A58A978-AD35-45B9-AB08-BC07DA3E5B9F',1,2,'PRDTESTE01','Chuteira Futsal Nike Beco 2',239.00,222,GETDATE(),GETDATE())
        INSERT INTO products VALUES('50B829A3-5ECC-45A2-981F-BCA0F551DD98',2,1,'TSTPRDSKU','Camisa Flamengo I 21/22 s/n° Torcedor Adidas Masculina',54.92,387,GETDATE(),GETDATE())
        INSERT INTO products VALUES('ED3E420D-DDCD-489D-9E2A-E94374B62F94',1,1,'PRDTESTE01','Short Adidas Club Masculino',239.00,222,GETDATE(),GETDATE())
        INSERT INTO products VALUES('7FB9B632-3711-42C4-991E-F94099D2ECA4',1,2,'TSTPRDSKU','Tênis Nike SB Charge Canvas',57.59,393,GETDATE(),GETDATE())
    END



GO
IF (SELECT COUNT(1) FROM Product_Colors) = 0
    BEGIN
        INSERT INTO product_colors VALUES('899309B8-7B19-4053-B9D7-024E014492E3','EFD81AF5-846F-40AA-A6E7-1528D07E5DDD','Azul Royal+Branco','https://static.netshoes.com.br/produtos/tenis-adidas-runfalcon-20-masculino/43/NQQ-6923-543/NQQ-6923-543_zoom4.jpg?ts=1616143211&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('3037030A-2FCC-4703-899A-02F27BA514BB','EFD81AF5-846F-40AA-A6E7-1528D07E5DDD','Cinza+Azul','https://static.netshoes.com.br/produtos/tenis-adidas-runfalcon-20-masculino/08/NQQ-6923-008/NQQ-6923-008_zoom3.jpg?ts=1616096227&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('C8A21166-12E9-4613-B48E-065181820546','B76E2151-24F3-4B39-BF6B-BAD0E786B38B','Preto+Branco','//static.netshoes.com.br/produtos/tenis-adidas-breaknet-masculino/26/NQQ-4378-026/NQQ-4378-026_zoom1.jpg?ts=1633973220',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('0C826846-58F5-444E-8CE6-0BAD96AF2A67','7FB9B632-3711-42C4-991E-F94099D2ECA4','Oliva','https://static.netshoes.com.br/produtos/tenis-nike-sb-charge-canvas/75/HZM-2998-775/HZM-2998-775_zoom3.jpg?ts=1607364110&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('77F2EAD3-C4DD-416B-B701-0ECCE96F91E5','46CCF84D-7D22-4891-BB41-B1B5D78DE545','Branco+Preto','//static.netshoes.com.br/produtos/shorts-tennis-club-adidas/28/2FW-5481-028/2FW-5481-028_zoom1.jpg?ts=1632466756',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('529AC444-3CD2-4FBC-9788-104AFF0A6A44','2C186CA7-D8D6-46BD-9103-3BB900E61B66','Preto+Off White','https://static.netshoes.com.br/produtos/tenis-nike-sb-chron-solarsoft/09/HZM-5102-309/HZM-5102-309_zoom3.jpg?ts=1622478932&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('860DD069-5891-4EB1-8AC3-13A250C2BC00','152744BB-D67E-43B0-AEED-3054B644E8EB','Vermelho+Branco','https://static.netshoes.com.br/produtos/tenis-nike-revolution-5-masculino/56/HZM-1731-056/HZM-1731-056_zoom3.jpg?ts=1597225919&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('07C57F17-2FB4-4A83-811D-16E52D6FE51F','7FB9B632-3711-42C4-991E-F94099D2ECA4','Preto','//static.netshoes.com.br/produtos/tenis-nike-sb-charge-canvas/06/HZM-2998-006/HZM-2998-006_zoom1.jpg?ts=1584657982',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('FAA5594B-B84E-439D-A684-20064DB382A8','DFA69DEF-77AA-4B66-876F-33CF04BC543F','Azul Petróleo','https://static.netshoes.com.br/produtos/camiseta-industrie-nyc-masculina/79/AD6-0504-879/AD6-0504-879_zoom2.jpg?ts=1642183728&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('A907236A-3958-41A5-9E5B-2092F256D849','2C186CA7-D8D6-46BD-9103-3BB900E61B66','Cinza+Branco','https://static.netshoes.com.br/produtos/tenis-nike-sb-chron-solarsoft/26/HZM-5102-226/HZM-5102-226_zoom3.jpg?ts=1622821671&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('2B9F41BF-0E67-4F8F-BC2F-2691A11608C9','DFA69DEF-77AA-4B66-876F-33CF04BC543F','Coral','https://static.netshoes.com.br/produtos/camiseta-industrie-basica-logo-masculina/23/AD6-0493-223/AD6-0493-223_zoom3.jpg?ts=1642183616&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('D9001C71-59FD-4B7B-AA42-297D32FCA0FD','3A58A978-AD35-45B9-AB08-BC07DA3E5B9F','Preto+Dourado','https://static.netshoes.com.br/produtos/chuteira-futsal-nike-beco-2/38/HZM-0953-038/HZM-0953-038_zoom4.jpg?ts=1617969042&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('AB3DC5DA-9540-4924-9C98-29C7C8197FE5','B76E2151-24F3-4B39-BF6B-BAD0E786B38B','Preto+Branco','https://static.netshoes.com.br/produtos/tenis-adidas-breaknet-masculino/26/NQQ-4378-026/NQQ-4378-026_zoom4.jpg?ts=1633973220&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('E1639CC7-ECDB-49ED-9B30-306889D97F2B','3A58A978-AD35-45B9-AB08-BC07DA3E5B9F','Vermelho+Branco','https://static.netshoes.com.br/produtos/chuteira-futsal-nike-beco-2/56/HZM-0953-056/HZM-0953-056_zoom2.jpg?ts=1599829016&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('17B3F380-2C16-4F49-B382-30BF913FCDA5','50B829A3-5ECC-45A2-981F-BCA0F551DD98','Vermelho+Preto','https://static.netshoes.com.br/produtos/camisa-flamengo-i-2122-sn-torcedor-adidas-masculina/68/NQQ-7755-068/NQQ-7755-068_zoom2.jpg?ts=1614691693&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('7D9027CA-09A3-473B-829B-321307819E03','DFA69DEF-77AA-4B66-876F-33CF04BC543F','Marinho','https://static.netshoes.com.br/produtos/camiseta-industrie-basica-logo-masculina/12/AD6-0493-012/AD6-0493-012_zoom2.jpg?ts=1642184050&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('8C9A4E67-20C3-44A3-A725-35997FBA5C5B','DFA69DEF-77AA-4B66-876F-33CF04BC543F','Marinho','https://static.netshoes.com.br/produtos/camiseta-industrie-basica-logo-masculina/12/AD6-0493-012/AD6-0493-012_zoom3.jpg?ts=1642184050&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('6073D63E-C224-4886-BF58-376512F8EAF5','ED3E420D-DDCD-489D-9E2A-E94374B62F94','Preto+Branco','https://static.netshoes.com.br/produtos/short-adidas-club-masculino/26/NQQ-6789-026/NQQ-6789-026_zoom3.jpg?ts=1621940568&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('6844CA16-C88B-4802-9BC9-38EEA4CFEF8C','2C186CA7-D8D6-46BD-9103-3BB900E61B66','Preto+Off White','https://static.netshoes.com.br/produtos/tenis-nike-sb-chron-solarsoft/09/HZM-5102-309/HZM-5102-309_zoom4.jpg?ts=1622478932&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('1E01D6D7-2498-4379-860B-3E86B97E839D','3A58A978-AD35-45B9-AB08-BC07DA3E5B9F','Preto+Dourado','https://static.netshoes.com.br/produtos/chuteira-futsal-nike-beco-2/38/HZM-0953-038/HZM-0953-038_zoom3.jpg?ts=1617969042&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('82982C25-BD9B-4CD0-BE82-48C354BC6EEA','DFA69DEF-77AA-4B66-876F-33CF04BC543F','Marinho','https://static.netshoes.com.br/produtos/camiseta-industrie-basica-logo-masculina/12/AD6-0493-012/AD6-0493-012_zoom4.jpg?ts=1642184050&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('1B9DC2C0-270A-4809-BC06-4A55B0042732','50B829A3-5ECC-45A2-981F-BCA0F551DD98','Vermelho+Preto','https://static.netshoes.com.br/produtos/camisa-flamengo-i-2122-sn-torcedor-adidas-masculina/68/NQQ-7755-068/NQQ-7755-068_zoom6.jpg?ts=1614691693&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('4EF2E350-173C-4B22-88D7-4AEA52B9740D','EFD81AF5-846F-40AA-A6E7-1528D07E5DDD','Cinza+Azul','https://static.netshoes.com.br/produtos/tenis-adidas-runfalcon-20-masculino/08/NQQ-6923-008/NQQ-6923-008_zoom1.jpg?ts=1616096227&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('0D7C7EF6-2C99-4DC5-82A9-4D3CEEB646A4','2C186CA7-D8D6-46BD-9103-3BB900E61B66','Cinza+Branco','https://static.netshoes.com.br/produtos/tenis-nike-sb-chron-solarsoft/26/HZM-5102-226/HZM-5102-226_zoom5.jpg?ts=1622821671&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('BAECD1F4-04B7-497C-8138-4DAA061F1888','DFA69DEF-77AA-4B66-876F-33CF04BC543F','Azul Petróleo','https://static.netshoes.com.br/produtos/camiseta-industrie-nyc-masculina/79/AD6-0504-879/AD6-0504-879_zoom3.jpg?ts=1642183728&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('092EEEA9-8FCF-4154-9FAB-5A20B8FE0357','50B829A3-5ECC-45A2-981F-BCA0F551DD98','Vermelho+Preto','https://static.netshoes.com.br/produtos/camisa-flamengo-i-2122-sn-torcedor-adidas-masculina/68/NQQ-7755-068/NQQ-7755-068_zoom4.jpg?ts=1614691693&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('3F566426-3266-4D46-9727-5B58AF3C44F7','3A58A978-AD35-45B9-AB08-BC07DA3E5B9F','Preto+Dourado','https://static.netshoes.com.br/produtos/chuteira-futsal-nike-beco-2/38/HZM-0953-038/HZM-0953-038_zoom2.jpg?ts=1617969042&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('F6BAB161-7584-4B84-A81A-5BA5D7D67178','ED3E420D-DDCD-489D-9E2A-E94374B62F94','Preto+Branco','https://static.netshoes.com.br/produtos/short-adidas-club-masculino/26/NQQ-6789-026/NQQ-6789-026_zoom4.jpg?ts=1621940568&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('2C5D9FEA-94E6-49BE-8867-5FDC6245B1E3','EFD81AF5-846F-40AA-A6E7-1528D07E5DDD','Cinza+Azul','https://static.netshoes.com.br/produtos/tenis-adidas-runfalcon-20-masculino/08/NQQ-6923-008/NQQ-6923-008_zoom4.jpg?ts=1616096227&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('30BF73F8-C1C2-46F6-A020-62F6197148CD','EFD81AF5-846F-40AA-A6E7-1528D07E5DDD','Azul Royal+Branco','https://static.netshoes.com.br/produtos/tenis-adidas-runfalcon-20-masculino/43/NQQ-6923-543/NQQ-6923-543_zoom2.jpg?ts=1616143211&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('CDEF8B8A-FB19-4953-A5DF-671D4711DDC5','EFD81AF5-846F-40AA-A6E7-1528D07E5DDD','Preto+Branco','//static.netshoes.com.br/produtos/tenis-adidas-runfalcon-20-masculino/26/NQQ-6923-026/NQQ-6923-026_zoom1.jpg?ts=1632156085',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('003729F8-8A5F-466B-9565-68D755E6186B','DFA69DEF-77AA-4B66-876F-33CF04BC543F','Coral','https://static.netshoes.com.br/produtos/camiseta-industrie-basica-logo-masculina/23/AD6-0493-223/AD6-0493-223_zoom4.jpg?ts=1642183616&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('4B3F7038-1543-4CC4-8BE2-7D3FEB161D1B','EFD81AF5-846F-40AA-A6E7-1528D07E5DDD','Azul Royal+Branco','//static.netshoes.com.br/produtos/tenis-adidas-runfalcon-20-masculino/43/NQQ-6923-543/NQQ-6923-543_zoom1.jpg?ts=1616143211',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('5A0BF576-93D5-43F7-96DD-817EE339E3A5','3A58A978-AD35-45B9-AB08-BC07DA3E5B9F','Vermelho+Branco','//static.netshoes.com.br/produtos/chuteira-futsal-nike-beco-2/56/HZM-0953-056/HZM-0953-056_zoom1.jpg?ts=1599829016',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('CFAF2DFA-963D-4238-9C09-81F3D86E513D','BAC24716-DAB7-4A74-A735-829A9C3A9063','Azul Navy','https://static.netshoes.com.br/produtos/camiseta-ecko-estampada-k163a-masculina/69/B25-5160-C69/B25-5160-C69_zoom2.jpg?ts=1637601387&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('CDEBADA5-20D1-4254-B171-834A3BA301E9','DFA69DEF-77AA-4B66-876F-33CF04BC543F','Coral','https://static.netshoes.com.br/produtos/camiseta-industrie-basica-logo-masculina/23/AD6-0493-223/AD6-0493-223_zoom2.jpg?ts=1642183616&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('F3A25833-ED35-4A62-89B5-85D175E9CD79','46CCF84D-7D22-4891-BB41-B1B5D78DE545','Branco+Preto','https://static.netshoes.com.br/produtos/shorts-tennis-club-adidas/28/2FW-5481-028/2FW-5481-028_zoom4.jpg?ts=1632466756&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('A4204170-7DF0-42C1-83D0-872E6D893B14','2C186CA7-D8D6-46BD-9103-3BB900E61B66','Preto+Off White','//static.netshoes.com.br/produtos/tenis-nike-sb-chron-solarsoft/09/HZM-5102-309/HZM-5102-309_zoom1.jpg?ts=1622478932',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('B8462192-08BE-4C1D-87C1-89EEE1680046','EFD81AF5-846F-40AA-A6E7-1528D07E5DDD','Preto+Branco','https://static.netshoes.com.br/produtos/tenis-adidas-runfalcon-20-masculino/26/NQQ-6923-026/NQQ-6923-026_zoom4.jpg?ts=1632156085&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('50AC0A0D-9469-41CC-885C-8BFF83A54EFC','B76E2151-24F3-4B39-BF6B-BAD0E786B38B','Branco+Preto','//static.netshoes.com.br/produtos/tenis-adidas-breaknet-masculino/28/NQQ-4378-028/NQQ-4378-028_zoom1.jpg?ts=1634216352',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('437382A8-EFB4-4D76-842B-8D7403D2AA7F','B76E2151-24F3-4B39-BF6B-BAD0E786B38B','Branco+Preto','https://static.netshoes.com.br/produtos/tenis-adidas-breaknet-masculino/28/NQQ-4378-028/NQQ-4378-028_zoom3.jpg?ts=1634216352&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('C5AE8090-E709-4C2D-A1E3-8E8E7A0385BA','BAC24716-DAB7-4A74-A735-829A9C3A9063','Azul Navy','https://static.netshoes.com.br/produtos/camiseta-ecko-estampada-k163a-masculina/69/B25-5160-C69/B25-5160-C69_zoom3.jpg?ts=1637601387&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('5228AAF7-0392-4925-A088-8EC3F053931F','3A58A978-AD35-45B9-AB08-BC07DA3E5B9F','Preto+Dourado','//static.netshoes.com.br/produtos/chuteira-futsal-nike-beco-2/38/HZM-0953-038/HZM-0953-038_zoom1.jpg?ts=1617969042',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('16D3C1E7-4EE0-4F24-AA4C-8FFB3F140F35','152744BB-D67E-43B0-AEED-3054B644E8EB','Vermelho+Branco','https://static.netshoes.com.br/produtos/tenis-nike-revolution-5-masculino/56/HZM-1731-056/HZM-1731-056_zoom2.jpg?ts=1597225919&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('EA0C367E-0D62-475F-A3F3-92C83E7139EC','7FB9B632-3711-42C4-991E-F94099D2ECA4','Oliva','//static.netshoes.com.br/produtos/tenis-nike-sb-charge-canvas/75/HZM-2998-775/HZM-2998-775_zoom1.jpg?ts=1607364110',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('179C8C8E-6372-46FA-8F9D-938DDB0256EF','46CCF84D-7D22-4891-BB41-B1B5D78DE545','Branco+Preto','https://static.netshoes.com.br/produtos/shorts-tennis-club-adidas/28/2FW-5481-028/2FW-5481-028_zoom2.jpg?ts=1632466756&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('78814F14-646A-43AB-8BB2-94C65E8FC431','EFD81AF5-846F-40AA-A6E7-1528D07E5DDD','Cinza+Azul','https://static.netshoes.com.br/produtos/tenis-adidas-runfalcon-20-masculino/08/NQQ-6923-008/NQQ-6923-008_zoom2.jpg?ts=1616096227&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('7D258878-C362-4394-BC8C-957BE464A66D','ED3E420D-DDCD-489D-9E2A-E94374B62F94','Preto+Branco','https://static.netshoes.com.br/produtos/short-adidas-club-masculino/26/NQQ-6789-026/NQQ-6789-026_zoom2.jpg?ts=1621940568&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('A0D56607-15F9-46B1-B4BE-973D3FA0870D','DFA69DEF-77AA-4B66-876F-33CF04BC543F','Coral','//static.netshoes.com.br/produtos/camiseta-industrie-basica-logo-masculina/23/AD6-0493-223/AD6-0493-223_zoom1.jpg?ts=1642183616',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('2AC000E7-1ECF-49F8-A631-9799C5B5E10B','B76E2151-24F3-4B39-BF6B-BAD0E786B38B','Preto+Branco','https://static.netshoes.com.br/produtos/tenis-adidas-breaknet-masculino/26/NQQ-4378-026/NQQ-4378-026_zoom2.jpg?ts=1633973220&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('5A8A39A5-71BE-423F-A948-9C459ED88307','ED3E420D-DDCD-489D-9E2A-E94374B62F94','Preto+Branco','//static.netshoes.com.br/produtos/short-adidas-club-masculino/26/NQQ-6789-026/NQQ-6789-026_zoom1.jpg?ts=1621940568',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('8456F02E-92F5-4650-868F-9D06C578F7ED','B76E2151-24F3-4B39-BF6B-BAD0E786B38B','Branco+Preto','https://static.netshoes.com.br/produtos/tenis-adidas-breaknet-masculino/28/NQQ-4378-028/NQQ-4378-028_zoom2.jpg?ts=1634216352&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('B71A93ED-C427-4905-92B9-A1603597581B','2C186CA7-D8D6-46BD-9103-3BB900E61B66','Preto+Off White','https://static.netshoes.com.br/produtos/tenis-nike-sb-chron-solarsoft/09/HZM-5102-309/HZM-5102-309_zoom2.jpg?ts=1622478932&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('3201F5EE-D7DB-492E-B436-A16F8307F91A','7FB9B632-3711-42C4-991E-F94099D2ECA4','Oliva','https://static.netshoes.com.br/produtos/tenis-nike-sb-charge-canvas/75/HZM-2998-775/HZM-2998-775_zoom2.jpg?ts=1607364110&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('7F98C414-D667-49E6-9B30-B03C600B0616','152744BB-D67E-43B0-AEED-3054B644E8EB','Vermelho+Branco','//static.netshoes.com.br/produtos/tenis-nike-revolution-5-masculino/56/HZM-1731-056/HZM-1731-056_zoom1.jpg?ts=1597225919',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('C64BD0EF-744C-42E3-ADAE-B52180434EEC','3A58A978-AD35-45B9-AB08-BC07DA3E5B9F','Vermelho+Branco','https://static.netshoes.com.br/produtos/chuteira-futsal-nike-beco-2/56/HZM-0953-056/HZM-0953-056_zoom3.jpg?ts=1599829016&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('1F2C68DD-A84C-4E38-93A2-BD3052CC4FF0','152744BB-D67E-43B0-AEED-3054B644E8EB','Vermelho+Branco','https://static.netshoes.com.br/produtos/tenis-nike-revolution-5-masculino/56/HZM-1731-056/HZM-1731-056_zoom4.jpg?ts=1597225919&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('C5268EC6-4486-46E4-87BF-BE348C70E66C','46CCF84D-7D22-4891-BB41-B1B5D78DE545','Branco+Preto','https://static.netshoes.com.br/produtos/shorts-tennis-club-adidas/28/2FW-5481-028/2FW-5481-028_zoom3.jpg?ts=1632466756&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('F355104B-1F29-4828-8EB4-BF5404EA72DD','50B829A3-5ECC-45A2-981F-BCA0F551DD98','Vermelho+Preto','https://static.netshoes.com.br/produtos/camisa-flamengo-i-2122-sn-torcedor-adidas-masculina/68/NQQ-7755-068/NQQ-7755-068_zoom3.jpg?ts=1614691693&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('478085CB-D286-4185-B201-C03D70C655A1','EFD81AF5-846F-40AA-A6E7-1528D07E5DDD','Azul Royal+Branco','https://static.netshoes.com.br/produtos/tenis-adidas-runfalcon-20-masculino/43/NQQ-6923-543/NQQ-6923-543_zoom3.jpg?ts=1616143211&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('2FB8A0A0-4BBC-4BDD-AC9C-C06D0F5ABB75','DFA69DEF-77AA-4B66-876F-33CF04BC543F','Marinho','//static.netshoes.com.br/produtos/camiseta-industrie-basica-logo-masculina/12/AD6-0493-012/AD6-0493-012_zoom1.jpg?ts=1642184050',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('BB3C85B7-045B-4CE6-8C8C-C17D2BC121A3','3A58A978-AD35-45B9-AB08-BC07DA3E5B9F','Vermelho+Branco','https://static.netshoes.com.br/produtos/chuteira-futsal-nike-beco-2/56/HZM-0953-056/HZM-0953-056_zoom5.jpg?ts=1599829016&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('CF3032FC-03A6-4944-839D-C51C2C6A443F','B76E2151-24F3-4B39-BF6B-BAD0E786B38B','Preto+Branco','https://static.netshoes.com.br/produtos/tenis-adidas-breaknet-masculino/26/NQQ-4378-026/NQQ-4378-026_zoom3.jpg?ts=1633973220&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('67FFD06A-8940-46AB-8FDF-CC8C9C6AC173','2C186CA7-D8D6-46BD-9103-3BB900E61B66','Cinza+Branco','https://static.netshoes.com.br/produtos/tenis-nike-sb-chron-solarsoft/26/HZM-5102-226/HZM-5102-226_zoom2.jpg?ts=1622821671&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('531D9608-DFDC-40D6-8B91-D59D0A167726','EFD81AF5-846F-40AA-A6E7-1528D07E5DDD','Preto+Branco','https://static.netshoes.com.br/produtos/tenis-adidas-runfalcon-20-masculino/26/NQQ-6923-026/NQQ-6923-026_zoom3.jpg?ts=1632156085&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('FA4E0D14-F21B-4F34-9731-E2A2E8BF997F','2C186CA7-D8D6-46BD-9103-3BB900E61B66','Cinza+Branco','//static.netshoes.com.br/produtos/tenis-nike-sb-chron-solarsoft/26/HZM-5102-226/HZM-5102-226_zoom1.jpg?ts=1622821671',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('1F47B7CB-7D55-480C-81D6-E654478E9128','7FB9B632-3711-42C4-991E-F94099D2ECA4','Preto','https://static.netshoes.com.br/produtos/tenis-nike-sb-charge-canvas/06/HZM-2998-006/HZM-2998-006_zoom2.jpg?ts=1584657982&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('EE2BA0AC-03E3-4A0C-8F60-E79566689179','DFA69DEF-77AA-4B66-876F-33CF04BC543F','Azul Petróleo','https://static.netshoes.com.br/produtos/camiseta-industrie-nyc-masculina/79/AD6-0504-879/AD6-0504-879_zoom4.jpg?ts=1642183728&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('A6796C59-1809-471A-A582-E7FBB87539E2','EFD81AF5-846F-40AA-A6E7-1528D07E5DDD','Preto+Branco','https://static.netshoes.com.br/produtos/tenis-adidas-runfalcon-20-masculino/26/NQQ-6923-026/NQQ-6923-026_zoom2.jpg?ts=1632156085&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('3274B083-C277-4242-BEDA-EAC1C30DFA2C','BAC24716-DAB7-4A74-A735-829A9C3A9063','Azul Navy','//static.netshoes.com.br/produtos/camiseta-ecko-estampada-k163a-masculina/69/B25-5160-C69/B25-5160-C69_zoom1.jpg?ts=1637601387	2022-01-18',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('2B642380-240E-44C6-8221-EDA1BB11B0CA','50B829A3-5ECC-45A2-981F-BCA0F551DD98','Vermelho+Preto','https://static.netshoes.com.br/produtos/camisa-flamengo-i-2122-sn-torcedor-adidas-masculina/68/NQQ-7755-068/NQQ-7755-068_zoom1.jpg?ts=1614691693',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('F739BD55-1498-4FCE-986D-F56FA02B3F3D','B76E2151-24F3-4B39-BF6B-BAD0E786B38B','Branco+Preto','https://static.netshoes.com.br/produtos/tenis-adidas-breaknet-masculino/28/NQQ-4378-028/NQQ-4378-028_zoom4.jpg?ts=1634216352&',GETDATE(),GETDATE())
        INSERT INTO product_colors VALUES('EBC10A24-3446-4E5E-9183-FD3FDE47AA06','DFA69DEF-77AA-4B66-876F-33CF04BC543F','Azul Petróleo','//static.netshoes.com.br/produtos/camiseta-industrie-nyc-masculina/79/AD6-0504-879/AD6-0504-879_zoom1.jpg?ts=1642183728',GETDATE(),GETDATE())

END



