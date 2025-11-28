DROP TABLE IF EXISTS CLIENTES;
DROP TABLE IF EXISTS PRODUCTOS;
DROP TABLE IF EXISTS INVENTARIO;
DROP TABLE IF EXISTS EMPLEADOS;
DROP TABLE IF EXISTS KIOSCOS;
DROP TABLE IF EXISTS PEDIDOS;
DROP TABLE IF EXISTS DETALLE_PEDIDO;
DROP TABLE IF EXISTS EVENTOS;

CREATE TABLE CLIENTES (
    ID_Cliente INTEGER PRIMARY KEY AUTOINCREMENT,
    Nombre TEXT NOT NULL,
    Telefono TEXT NOT NULL,
    Email TEXT,
    Direccion TEXT,
    Fecha_Registro TEXT DEFAULT CURRENT_TIMESTAMP,
    Tipo_Cliente TEXT CHECK (Tipo_Cliente IN ('Regular','Evento','VIP'))
);

CREATE TABLE PRODUCTOS (
    ID_Producto INTEGER PRIMARY KEY AUTOINCREMENT,
    Nombre TEXT NOT NULL,
    Descripcion TEXT,
    Precio REAL NOT NULL,
    Categoria TEXT CHECK (Categoria IN ('Tacos','Bebidas','Complementos','Paquetes')),
    Tiempo_Preparacion INTEGER,
    Disponible INTEGER CHECK(Disponible IN (0,1)) DEFAULT 1
);

CREATE TABLE INVENTARIO (
    ID_Inventario INTEGER PRIMARY KEY AUTOINCREMENT,
    ID_Producto INTEGER NOT NULL,
    Stock_Actual INTEGER NOT NULL,
    Stock_Minimo INTEGER NOT NULL,
    Ultima_Actualizacion TEXT DEFAULT CURRENT_TIMESTAMP,
    Costo_Unitario REAL NOT NULL,
    Proveedor TEXT,
    FOREIGN KEY (ID_Producto) REFERENCES PRODUCTOS(ID_Producto)
);

CREATE TABLE EMPLEADOS (
    ID_Empleado INTEGER PRIMARY KEY AUTOINCREMENT,
    Nombre_Completo TEXT NOT NULL,
    Puesto TEXT NOT NULL,
    Telefono TEXT,
    Fecha_Ingreso TEXT DEFAULT CURRENT_TIMESTAMP,
    Turno TEXT CHECK (Turno IN ('Matutino','Vespertino','Mixto')),
    Salario REAL
);

CREATE TABLE KIOSCOS (
    ID_Kiosco INTEGER PRIMARY KEY AUTOINCREMENT,
    Ubicacion TEXT NOT NULL,
    Estado TEXT CHECK (Estado IN ('Activo','Inactivo','Mantenimiento')),
    Version_Software TEXT,
    Fecha_Instalacion TEXT,
    IP_Address TEXT,
    Ultimo_Mantenimiento TEXT
);

CREATE TABLE PEDIDOS (
    ID_Pedido INTEGER PRIMARY KEY AUTOINCREMENT,
    ID_Cliente INTEGER,
    ID_Empleado INTEGER,
    ID_Kiosco INTEGER,
    Fecha_Pedido TEXT DEFAULT CURRENT_TIMESTAMP,
    Tipo_Pedido TEXT CHECK (Tipo_Pedido IN ('Autoservicio','Evento','Tradicional')),
    Estado_Pedido TEXT CHECK (Estado_Pedido IN ('Pendiente','En Preparación','Listo','Entregado','Cancelado')),
    Total REAL,
    Metodo_Pago TEXT CHECK (Metodo_Pago IN ('Efectivo','Tarjeta','Transferencia')),
    FOREIGN KEY (ID_Cliente) REFERENCES CLIENTES(ID_Cliente),
    FOREIGN KEY (ID_Empleado) REFERENCES EMPLEADOS(ID_Empleado),
    FOREIGN KEY (ID_Kiosco) REFERENCES KIOSCOS(ID_Kiosco)
);

CREATE TABLE DETALLE_PEDIDO (
    ID_Detalle INTEGER PRIMARY KEY AUTOINCREMENT,
    ID_Pedido INTEGER NOT NULL,
    ID_Producto INTEGER NOT NULL,
    Cantidad INTEGER NOT NULL,
    Precio_Unitario REAL NOT NULL,
    FOREIGN KEY (ID_Pedido) REFERENCES PEDIDOS(ID_Pedido),
    FOREIGN KEY (ID_Producto) REFERENCES PRODUCTOS(ID_Producto)
);

CREATE TABLE EVENTOS (
    ID_Evento INTEGER PRIMARY KEY AUTOINCREMENT,
    ID_Cliente INTEGER NOT NULL,
    ID_Pedido INTEGER NOT NULL,
    Tipo_Evento TEXT CHECK (Tipo_Evento IN ('Piñata','Fiesta','Reunión Familiar')),
    Fecha_Evento TEXT NOT NULL,
    Numero_Personas INTEGER,
    Direccion_Evento TEXT NOT NULL,
    Estado_Evento TEXT CHECK (Estado_Evento IN ('Programado','Confirmado','Completado','Cancelado')),
    FOREIGN KEY (ID_Cliente) REFERENCES CLIENTES(ID_Cliente),
    FOREIGN KEY (ID_Pedido) REFERENCES PEDIDOS(ID_Pedido)
);

INSERT INTO CLIENTES (ID_Cliente, Nombre, Telefono, Email, Direccion, Tipo_Cliente)
VALUES
(1,'Adilene Vega', '6681234567', 'adiv@gmail.com', 'Col. Centro#123', 'Regular'),
(2,'Fernanda Castro ', '6687654321', 'Fer12@hotmail.com', 'Col. Jiquilpan #54', 'Evento'),
(3,'Vivian Verduzco ', '6689988776', 'viv@gmail.com', 'Col. Scally #88', 'VIP'),
(4,'Juan Pérez', '6681234567', 'juan@gmail.com', 'Col. Centro#2123', 'Regular'),
(5,'María López', '6687654321', 'maria@hotmail.com', 'Col. Las Flores #75', 'Evento'),
(6,'Martha Valenzuela', '6981976422', 'martha@hotmail.com', 'Col. Las Cerezas #52', 'Regular');

INSERT INTO PRODUCTOS (ID_Producto, Nombre, Descripcion, Precio, Categoria, Tiempo_Preparacion, Disponible) VALUES
(10, 'Taco de Vapor', 'Taco tradicional al vapor', 15, 'Tacos', 2, 1),
(11, 'Horchata 500ml', 'Agua de horchata fresca', 20, 'Bebidas', 1, 1),
(12, 'Paquete Fiesta', '50 tacos + 5 bebidas', 600, 'Paquetes', 10, 1),
(13, 'Taco de Harina', 'Taco de harina relleno', 18, 'Tacos', 3, 1),
(14, 'Refresco 600ml', 'Coca-Cola 600ml', 22, 'Bebidas', 1, 1),
(15, 'Salsa Especial', 'Salsa casera muy picante', 10, 'Complementos', 1, 1),
(16, 'Taco Dorado', 'Taco dorado crujiente', 17, 'Tacos', 3, 1);

INSERT INTO INVENTARIO (ID_Inventario, ID_Producto, Stock_Actual, Stock_Minimo, Costo_Unitario, Proveedor) VALUES
(20, 10, 200, 50, 5, 'Carnes López'),
(21, 11, 50, 10, 8, 'Abarrotes del Valle'),
(22, 12, 5, 1, 300, 'Mayorista Sinaloa'),
(23, 13, 150, 40, 6, 'Distribuidora Harinas MX'),
(24, 14, 80, 20, 10, 'Coca-Cola Sinaloa'),
(25, 15, 40, 10, 3, 'Chiles y Salsas del Pacífico'),
(26, 16, 120, 25, 7, 'Carnes del Norte');

INSERT INTO EMPLEADOS (ID_Empleado, Nombre_Completo, Puesto, Telefono, Turno, Salario) VALUES
(30, 'Pedro Hernández', 'Cajero', '6681112233', 'Matutino', 8500),
(31, 'Luisa Martínez', 'Cocinera', '6684445566', 'Mixto', 9500),
(32, 'Roberto Aguilar', 'Mesero', '6683332211', 'Vespertino', 7800),
(33, 'Diana Robles', 'Supervisora', '6682233445', 'Mixto', 12000);

INSERT INTO KIOSCOS (ID_Kiosco, Ubicacion, Estado, Version_Software, Fecha_Instalacion, IP_Address) VALUES
(40, 'Entrada principal', 'Activo', 'v1.2.3', '2024-10-01', '192.168.1.20'),
(41, 'Estacionamiento', 'Mantenimiento', 'v1.1.0', '2024-09-15', '192.168.1.21'),
(42, 'Zona de mesas', 'Activo', 'v1.2.3', '2024-11-05', '192.168.1.22');

INSERT INTO PEDIDOS (ID_Pedido, ID_Cliente, ID_Empleado, ID_Kiosco, Tipo_Pedido, Estado_Pedido, Total, Metodo_Pago) VALUES
(50, 1, 30, NULL, 'Tradicional', 'Entregado', 150, 'Efectivo'),
(51, 2, NULL, 40, 'Autoservicio', 'Listo', 35, 'Tarjeta'),
(52, 3, 31, NULL, 'Evento', 'Pendiente', 600, 'Transferencia'),
(53, 4, 32, 41, 'Tradicional', 'En Preparación', 45, 'Efectivo'),
(54, 5, NULL, 42, 'Autoservicio', 'Pendiente', 20, 'Tarjeta'),
(55, 6, 33, NULL, 'Tradicional', 'Entregado', 70, 'Efectivo'),
(56, 2, 32, NULL, 'Evento', 'Entregado', 1200, 'Transferencia'),
(57, 3, NULL, 42, 'Autoservicio', 'Cancelado', 0, 'Tarjeta'),
(58, 1, 31, 41, 'Tradicional', 'Pendiente', 85, 'Efectivo'),
(59, 5, 30, NULL, 'Evento', 'En Preparación', 450, 'Tarjeta'),
(60, 6, NULL, 40, 'Autoservicio', 'Listo', 55, 'Efectivo'),
(61, 2, 31, NULL, 'Tradicional', 'Entregado', 95, 'Transferencia'),
(62, 3, 33, 41, 'Evento', 'Pendiente', 800, 'Tarjeta'),
(63, 4, NULL, 42, 'Autoservicio', 'En Preparación', 40, 'Efectivo'),
(64, 5, 32, NULL, 'Tradicional', 'Cancelado', 0, 'Tarjeta'),
(65, 6, 30, 40, 'Evento', 'Entregado', 1500, 'Transferencia');

INSERT INTO DETALLE_PEDIDO (ID_Detalle, ID_Pedido, ID_Producto, Cantidad, Precio_Unitario) VALUES
(66, 50, 10, 10, 15),
(67, 51, 11, 1, 20),
(68, 52, 12, 1, 600),
(69, 53, 12, 3, 15),
(70, 53, 12, 1, 10),
(71, 54, 12, 1, 22),
(72, 55, 13, 2, 18),
(74, 55, 11, 1, 20),
(75, 56, 10, 12, 100),      
(76, 57, 11, 1, 20),      
(77, 58, 10, 5, 17),        
(78, 59, 14, 9, 50),      
(79, 60, 14, 2, 27.5),     
(80, 61, 13, 5, 19),       
(81, 62, 10, 8, 100),       
(82, 63, 15, 2, 20),      
(83, 64, 11, 1, 20),        
(84, 65, 16, 10, 150);  

INSERT INTO EVENTOS (ID_Evento, ID_Cliente, ID_Pedido, Tipo_Evento, Fecha_Evento, Numero_Personas, Direccion_Evento, Estado_Evento) VALUES
(85, 2, 52, 'Fiesta', '2024-12-15', 50, 'Salón Campestre #45', 'Programado'),
(86, 3, 53, 'Reunión Familiar', '2025-01-20', 30, 'Col. Santa Alicia #77', 'Confirmado'),
(87, 5, 56, 'Piñata', '2025-02-10', 20, 'Terraza Colinas #12', 'Programado');

SELECT * FROM CLIENTES;
SELECT * FROM PRODUCTOS;
SELECT * FROM INVENTARIO;
SELECT * FROM EMPLEADOS;
SELECT * FROM KIOSCOS;
SELECT * FROM PEDIDOS;
SELECT * FROM DETALLE_PEDIDO;
SELECT * FROM EVENTOS;