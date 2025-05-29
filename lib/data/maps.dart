import 'package:flutter/material.dart';


final List<Map<String, dynamic>> restaurants = [
  {
    'image': 'assets/cuphead.jpg',
    'title': 'Cuphead Coffee',
    'seats': 7,
    'totalSeats': 18,
    'rating': 4,
    'favorites': 12,
    'phone': 12,
    'image-map': 'assets/map_cuphead.png',
    'direction': 'Av. Principal #101, Ciudad Hidalgo, Michoacán',
    'horariosDisponibles': {
      'inicio': TimeOfDay(hour: 7, minute: 0),
      'fin': TimeOfDay(hour: 21, minute: 0),
    },
    'services': ['Área temática', 'Arcade', 'Menú retro'],
    'isFavorite': true,
  },
  {
    'image': 'assets/spesso.png',
    'title': 'Spesso Coffee',
    'seats': 7,
    'totalSeats': 20,
    'rating': 4,
    'favorites': 15,
    'phone': 13,
    'image-map': 'assets/map_spesso.png',
    'direction': 'Av. Principal #123, Ciudad Hidalgo, Michoacán',
    'horariosDisponibles': {
      'inicio': TimeOfDay(hour: 7, minute: 0),
      'fin': TimeOfDay(hour: 20, minute: 0),
    },
    'services': ['Área VIP', 'Eventos en vivo', 'Menú gourmet'],
    'isFavorite': false,
  },
  {
    'image': 'assets/golden.png',
    'title': 'Golden Coffee',
    'seats': 5,
    'totalSeats': 16,
    'rating': 5,
    'favorites': 18,
    'phone': 14,
    'image-map': 'assets/map_golden.png',
    'direction': 'Calle Dorada #55, Ciudad Hidalgo, Michoacán',
    'horariosDisponibles': {
      'inicio': TimeOfDay(hour: 8, minute: 0),
      'fin': TimeOfDay(hour: 22, minute: 0),
    },
    'services': ['Reservas exclusivas', 'Menú dorado', 'Terraza'],
    'isFavorite': true,
  },
];

List<Map<String, dynamic>> generarMesas(List<Map<String, dynamic>> restaurants) {
  final List<Map<String, dynamic>> mesasGeneradas = [];

  for (final restaurante in restaurants) {
    final int totalMesas = restaurante['totalSeats'] ?? 0;
    final String titulo = restaurante['title'] ?? 'Desconocido';
    final String imagen = restaurante['image'] ?? '';

    for (int i = 1; i <= totalMesas; i++) {
      mesasGeneradas.add({
        'nombre': 'Mesa $i',
        'capacidad': (i % 6) + 2, // Capacidad entre 2 y 7
        'imagen': 'assets/table1.png',
        'mensaje': 'Mesa generada automáticamente',
        'status': 'Disponible',
        'title': titulo,
        'reservada': false,
        'fechaReserva': null, 
        'horaReserva': null, 
      });
    }
  }

  return mesasGeneradas;
}

final List<Map<String, dynamic>> tables = generarMesas(restaurants);

Map<String, Map<String, List<Map<String, dynamic>>>> generateMenu(String restaurantTitle) {
  const Map<String, Map<String, List<Map<String, dynamic>>>> baseMenu = {
    'Spesso Coffee': {
      'Entradas': [
        {'name': 'Bruschetta Italiana', 'description': 'Pan tostado con tomate y albahaca', 'price': 8.50, 'image': 'starter1.png'},
        {'name': 'Ensalada Caprese', 'description': 'Tomate, mozzarella y albahaca', 'price': 9.99, 'image': 'starter2.png'},
      ],
      'Platos Principales': [
        {'name': 'Pasta Alfredo', 'description': 'Pasta cremosa con pollo', 'price': 14.99, 'image': 'main1.png'},
        {'name': 'Risotto de Champiñones', 'description': 'Arroz cremoso con champiñones frescos', 'price': 16.50, 'image': 'main2.png'},
      ],
      'Postres': [
        {'name': 'Tiramisú', 'description': 'Postre italiano con café y mascarpone', 'price': 6.50, 'image': 'dessert1.png'},
        {'name': 'Gelato de Pistacho', 'description': 'Helado artesanal italiano', 'price': 5.99, 'image': 'dessert2.png'},
      ],
      'Bebidas': [
        {'name': 'Latte Vainilla', 'description': 'Suave espresso con aroma de vainilla', 'price': 4.99, 'image': 'drink1.png'},
        {'name': 'Espresso Doble', 'description': 'Café intenso y concentrado', 'price': 3.75, 'image': 'drink2.png'},
      ],
      'Especialidades': [
        {'name': 'Café Artesanal Italiano', 'description': 'Selección de granos importados', 'price': 7.99, 'image': 'special1.png'},
      ],
    },
    'Cuphead Coffee': {
      'Tapas y Bocadillos': [
        {'name': 'Papas Cuphead', 'description': 'Crujientes y sabrosas', 'price': 7.50, 'image': 'cuphead_ent1.png'},
        {'name': 'Nachos con Guacamole', 'description': 'Totopos con guacamole fresco', 'price': 8.99, 'image': 'cuphead_ent2.png'},
      ],
      'Menú Ejecutivo': [
        {'name': 'Hamburguesa Retro', 'description': 'Estilo años 50', 'price': 13.50, 'image': 'cuphead_main1.png'},
        {'name': 'Club Sándwich', 'description': 'Pan tostado con pollo, tocino y aderezo', 'price': 12.99, 'image': 'cuphead_main2.png'},
      ],
      'Postres': [
        {'name': 'Pastelito', 'description': 'Pequeño pero delicioso', 'price': 5.50, 'image': 'cuphead_dessert1.png'},
        {'name': 'Galletas Caseras', 'description': 'Dulces de mantequilla horneados', 'price': 4.99, 'image': 'cuphead_dessert2.png'},
      ],
      'Cócteles y Bebidas': [
        {'name': 'Malteada', 'description': 'Vainilla o fresa', 'price': 6.00, 'image': 'cuphead_drink1.png'},
        {'name': 'Café Nitro', 'description': 'Infusión de café frío con gas', 'price': 7.50, 'image': 'cuphead_drink2.png'},
      ],
    },
    'Golden Coffee': {
      'Desayunos Saludables': [
        {'name': 'Tostadas Gourmet', 'description': 'Con aguacate y huevo', 'price': 6.50, 'image': 'golden_ent1.png'},
        {'name': 'Parfait de Yogurt', 'description': 'Con frutos rojos y granola', 'price': 7.99, 'image': 'golden_ent2.png'},
      ],
      'Platos Fuertes': [
        {'name': 'Pollo Golden', 'description': 'Al curry', 'price': 15.00, 'image': 'golden_main1.png'},
        {'name': 'Salmón a la Parrilla', 'description': 'Con verduras salteadas', 'price': 17.99, 'image': 'golden_main2.png'},
      ],
      'Postres Gourmet': [
        {'name': 'Pan de Elote', 'description': 'Calientito y dulce', 'price': 5.99, 'image': 'golden_dessert1.png'},
        {'name': 'Fondant de Chocolate', 'description': 'Tarta de chocolate rellena', 'price': 7.50, 'image': 'golden_dessert2.png'},
      ],
      'Bebidas Naturales': [
        {'name': 'Limonada de Jengibre', 'description': 'Refrescante', 'price': 4.75, 'image': 'golden_drink1.png'},
        {'name': 'Té Helado de Frutas', 'description': 'Infusión de frutas tropicales', 'price': 5.99, 'image': 'golden_drink2.png'},
      ],
    },
  };

  return baseMenu.containsKey(restaurantTitle)
      ? {restaurantTitle: baseMenu[restaurantTitle]!}
      : {
          restaurantTitle: {
            'Entradas': [],
            'Platos Principales': [],
            'Postres': [],
            'Bebidas': [],
            'Especialidades': [],
            'Tapas y Bocadillos': [],
            'Menú Ejecutivo': [],
            'Cócteles y Bebidas': [],
            'Desayunos Saludables': [],
            'Platos Fuertes': [],
            'Postres Gourmet': [],
            'Bebidas Naturales': [],
          }
        };
}

final Map<String, Map<String, List<Map<String, dynamic>>>> allMenus = {
  for (final r in restaurants) ...generateMenu(r['title']),
};

final List<Map<String, dynamic>> opiniones = [
  {
    'title': 'Cuphead Coffee',
    'reviews': [
      {'user': 'Carlos Martínez', 'rating': 4.5, 'comment': 'Excelente café y ambiente retro.'},
      {'user': 'Ana Gómez', 'rating': 5.0, 'comment': 'El mejor espresso que he probado.'},
      {'user': 'Rubén Pérez', 'rating': 4.2, 'comment': 'Muy buen servicio y decoración original.'},
    ],
  },
  {
    'title': 'Spesso Coffee',
    'reviews': [
      {'user': 'Luis Rodríguez', 'rating': 3.8, 'comment': 'Buena atención, pero el café podría mejorar.'},
      {'user': 'María López', 'rating': 4.7, 'comment': 'Gran variedad de postres y café delicioso.'},
      {'user': 'Andrea Sánchez', 'rating': 4.3, 'comment': 'Ambiente tranquilo, ideal para trabajar.'},
    ],
  },
  {
    'title': 'Golden Coffee',
    'reviews': [
      {'user': 'Fernando Pérez', 'rating': 4.2, 'comment': 'Buen lugar para trabajar y disfrutar un café.'},
      {'user': 'Sofía Hernández', 'rating': 4.8, 'comment': 'Ambiente acogedor y excelente servicio.'},
      {'user': 'Gabriel Torres', 'rating': 4.6, 'comment': 'Terraza increíble y postres muy buenos.'},
    ],
  },
];

final List<Map<String, dynamic>> usuarios = [
  {
    'nombre': 'Jorge Osvaldo',
    'apellido': 'Feliciano', 
    'username': '@Mr0TTiZ',
    'correo': 'jorge.osvaldo@email.com',
    'password': '123456',
    'fechaRegistro': 'Febrero 2019',
    'telefono': '5522334455', 
    'fechaNacimiento': '15 de Julio de 1995', 
    'codigoPostal': '10010', 
    'ciudad': 'Ciudad Hidalgo', 
    'pais': 'México',
    'favoritos': '5',
    'reseñas': '18',
    'seguidores': '13',
    'puntos': '507',
    'visitas': '78',
  },
];

final List<Map<String, dynamic>> historialCompras = [
  {
    'fecha': '28/05/2025',
    'total': 30.00,
    'estado': 'Completada',
    'productos': [
      {'nombre': 'Hamburguesa', 'cantidad': 2, 'precio': 10.00},
      {'nombre': 'Papas fritas', 'cantidad': 1, 'precio': 5.00},
      {'nombre': 'Refresco', 'cantidad': 1, 'precio': 5.00},
    ],
  },
  {
    'fecha': '27/05/2025',
    'total': 45.00,
    'estado': 'Pendiente',
    'productos': [
      {'nombre': 'Pizza', 'cantidad': 1, 'precio': 20.00},
      {'nombre': 'Ensalada', 'cantidad': 1, 'precio': 10.00},
      {'nombre': 'Jugo', 'cantidad': 2, 'precio': 7.50},
    ],
  },
];

final List<Map<String, dynamic>> carritoCompras = [];