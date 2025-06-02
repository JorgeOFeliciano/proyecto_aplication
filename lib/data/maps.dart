Map<String, Map<String, dynamic>> allUsersData = {};

/// Inicializa la estructura de datos para un usuario
void initUserData(String username) {
  allUsersData.putIfAbsent(username, () => {
        'carrito': [],
        'reservas': [],
        'favoritos': [],
      });
}

final List<Map<String, dynamic>> restaurants = [
  {
    'id': 'R001',
    'ownerId': 'U001', // ✅ Vinculado con Jorge Osvaldo
    'image': 'assets/cuphead.jpg',
    'title': 'Cuphead Coffee',
    'seats': 7,
    'totalSeats': 18,
    'rating': 4,
    'favorites': 12,
    'phone': '5522334455',
    'image-map': 'assets/map_cuphead.png',
    'direction': 'Av. Principal #101, Ciudad Hidalgo, Michoacán',
    'horariosDisponibles': {
      'inicio': '07:00',
      'fin': '21:00',
    },
    'services': ['Área temática', 'Arcade', 'Menú retro'],
    'isFavorite': true,
  },
  {
    'id': 'R002',
    'ownerId': 'U003', // ✅ Vinculado con Carlos Alberto
    'image': 'assets/spesso.png',
    'title': 'Spesso Coffee',
    'seats': 7,
    'totalSeats': 20,
    'rating': 4,
    'favorites': 15,
    'phone': '5599887766',
    'image-map': 'assets/map_spesso.png',
    'direction': 'Av. Principal #123, Ciudad Hidalgo, Michoacán',
    'horariosDisponibles': {
      'inicio': '07:00',
      'fin': '21:00',
    },
    'services': ['Área VIP', 'Eventos en vivo', 'Menú gourmet'],
    'isFavorite': false,
  },
  {
    'id': 'R003',
    'ownerId': null,
    'image': 'assets/golden.png',
    'title': 'Golden Coffee',
    'seats': 5,
    'totalSeats': 16,
    'rating': 5,
    'favorites': 18,
    'phone': '5511223344',
    'image-map': 'assets/map_golden.png',
    'direction': 'Calle Dorada #55, Ciudad Hidalgo, Michoacán',
    'horariosDisponibles': {
      'inicio': '07:00',
      'fin': '21:00',
    },
    'services': ['Reservas exclusivas', 'Menú dorado', 'Terraza'],
    'isFavorite': true,
  },
];List<Map<String, dynamic>> generarMesas(List<Map<String, dynamic>> restaurants) {

  
final List<Map<String, dynamic>> mesasGeneradas = [];
  for (final restaurante in restaurants) {
    final int totalMesas = restaurante['totalSeats'] ?? 0;
    final String titulo = restaurante['title'] ?? 'Desconocido';
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

void actualizarFavorito(String restaurantTitle) {
  for (var i = 0; i < restaurants.length; i++) {
    if (restaurants[i]['title'] == restaurantTitle) {
      restaurants[i]['isFavorite'] = !(restaurants[i]['isFavorite'] ?? false);
      break;
    }
  }
}

Map<String, Map<String, List<Map<String, dynamic>>>> generateMenu(String restaurantTitle) {
  final Map<String, Map<String, List<Map<String, dynamic>>>> baseMenu = {
    'Spesso Coffee': {
      'Entradas': [
        {
          'name': 'Bruschetta Italiana',
          'description': 'Pan tostado con tomate y albahaca',
          'price': 8.50,
          'image': 'starter1.png'
        },
        {
          'name': 'Ensalada Caprese',
          'description': 'Tomate, mozzarella y albahaca',
          'price': 9.99,
          'image': 'starter2.png'
        },
      ],
      'Platos Principales': [
        {
          'name': 'Pasta Alfredo',
          'description': 'Pasta cremosa con pollo',
          'price': 14.99,
          'image': 'main1.png'
        },
        {
          'name': 'Risotto de Champiñones',
          'description': 'Arroz cremoso con champiñones frescos',
          'price': 16.50,
          'image': 'main2.png'
        },
      ],
      'Postres': [
        {
          'name': 'Tiramisú',
          'description': 'Postre italiano con café y mascarpone',
          'price': 6.50,
          'image': 'dessert1.png'
        },
        {
          'name': 'Gelato de Pistacho',
          'description': 'Helado artesanal italiano',
          'price': 5.99,
          'image': 'dessert2.png'
        },
      ],
      'Bebidas': [
        {
          'name': 'Latte Vainilla',
          'description': 'Suave espresso con aroma de vainilla',
          'price': 4.99,
          'image': 'drink1.png'
        },
        {
          'name': 'Espresso Doble',
          'description': 'Café intenso y concentrado',
          'price': 3.75,
          'image': 'drink2.png'
        },
      ],
      'Especialidades': [
        {
          'name': 'Café Artesanal Italiano',
          'description': 'Selección de granos importados',
          'price': 7.99,
          'image': 'special1.png'
        },
      ],
    },
    'Cuphead Coffee': {
      'Tapas y Bocadillos': [
        {
          'name': 'Papas Cuphead',
          'description': 'Crujientes y sabrosas',
          'price': 7.50,
          'image': 'cuphead_ent1.png'
        },
        {
          'name': 'Nachos con Guacamole',
          'description': 'Totopos con guacamole fresco',
          'price': 8.99,
          'image': 'cuphead_ent2.png'
        },
      ],
      'Menú Ejecutivo': [
        {
          'name': 'Hamburguesa Retro',
          'description': 'Estilo años 50',
          'price': 13.50,
          'image': 'cuphead_main1.png'
        },
        {
          'name': 'Club Sándwich',
          'description': 'Pan tostado con pollo, tocino y aderezo',
          'price': 12.99,
          'image': 'cuphead_main2.png'
        },
      ],
      'Postres': [
        {
          'name': 'Pastelito',
          'description': 'Pequeño pero delicioso',
          'price': 5.50,
          'image': 'cuphead_dessert1.png'
        },
        {
          'name': 'Galletas Caseras',
          'description': 'Dulces de mantequilla horneados',
          'price': 4.99,
          'image': 'cuphead_dessert2.png'
        },
      ],
      'Cócteles y Bebidas': [
        {
          'name': 'Malteada',
          'description': 'Vainilla o fresa',
          'price': 6.00,
          'image': 'cuphead_drink1.png'
        },
        {
          'name': 'Café Nitro',
          'description': 'Infusión de café frío con gas',
          'price': 7.50,
          'image': 'cuphead_drink2.png'
        },
      ],
    },
    'Golden Coffee': {
      'Desayunos Saludables': [
        {
          'name': 'Tostadas Gourmet',
          'description': 'Con aguacate y huevo',
          'price': 6.50,
          'image': 'golden_ent1.png'
        },
        {
          'name': 'Parfait de Yogurt',
          'description': 'Con frutos rojos y granola',
          'price': 7.99,
          'image': 'golden_ent2.png'
        },
      ],
      'Platos Fuertes': [
        {
          'name': 'Pollo Golden',
          'description': 'Al curry',
          'price': 15.00,
          'image': 'golden_main1.png'
        },
        {
          'name': 'Salmón a la Parrilla',
          'description': 'Con verduras salteadas',
          'price': 17.99,
          'image': 'golden_main2.png'
        },
      ],
      'Postres Gourmet': [
        {
          'name': 'Pan de Elote',
          'description': 'Calientito y dulce',
          'price': 5.99,
          'image': 'golden_dessert1.png'
        },
        {
          'name': 'Fondant de Chocolate',
          'description': 'Tarta de chocolate rellena',
          'price': 7.50,
          'image': 'golden_dessert2.png'
        },
      ],
      'Bebidas Naturales': [
        {
          'name': 'Limonada de Jengibre',
          'description': 'Refrescante',
          'price': 4.75,
          'image': 'golden_drink1.png'
        },
        {
          'name': 'Té Helado de Frutas',
          'description': 'Infusión de frutas tropicales',
          'price': 5.99,
          'image': 'golden_drink2.png'
        },
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
      {
        'user': 'Carlos Martínez',
        'rating': 4.5,
        'comment': 'Excelente café y ambiente retro.'
      },
      {
        'user': 'Ana Gómez',
        'rating': 5.0,
        'comment': 'El mejor espresso que he probado.'
      },
      {
        'user': 'Rubén Pérez',
        'rating': 4.2,
        'comment': 'Muy buen servicio y decoración original.'
      },
    ],
  },
  {
    'title': 'Spesso Coffee',
    'reviews': [
      {
        'user': 'Luis Rodríguez',
        'rating': 3.8,
        'comment': 'Buena atención, pero el café podría mejorar.'
      },
      {
        'user': 'María López',
        'rating': 4.7,
        'comment': 'Gran variedad de postres y café delicioso.'
      },
      {
        'user': 'Andrea Sánchez',
        'rating': 4.3,
        'comment': 'Ambiente tranquilo, ideal para trabajar.'
      },
    ],
  },
  {
    'title': 'Golden Coffee',
    'reviews': [
      {
        'user': 'Fernando Pérez',
        'rating': 4.2,
        'comment': 'Buen lugar para trabajar y disfrutar un café.'
      },
      {
        'user': 'Sofía Hernández',
        'rating': 4.8,
        'comment': 'Ambiente acogedor y excelente servicio.'
      },
      {
        'user': 'Gabriel Torres',
        'rating': 4.6,
        'comment': 'Terraza increíble y postres muy buenos.'
      },
    ],
  },
];


final List<Map<String, dynamic>> usuarios = [
  {
    'id': 'U001',
    'nombre': 'Jorge Osvaldo',
    'apellido': 'Feliciano',
    'username': 'Mr0TTiZ',
    'correo': 'jorge.osvaldo@email.com',
    'password': '123456',
    'fechaRegistro': 'Febrero 2019',
    'telefono': '5522334455',
    'fechaNacimiento': '15/07/1995',
    'codigoPostal': '10010',
    'ciudad': 'Ciudad Hidalgo',
    'pais': 'México',
    'favoritos': '5',
    'reseñas': '18',
    'seguidores': '13',
    'puntos': '507',
    'visitas': '78',
    'sexo': 'Masculino',
    'tieneRestaurante': true, // ✅ Vinculación con restaurante
  },
  {
    'id': 'U002',
    'nombre': 'María Luisa',
    'apellido': 'García',
    'username': 'MariaG',
    'correo': 'maria.garcia@email.com',
    'password': 'password123',
    'fechaRegistro': 'Marzo 2020',
    'telefono': '5511223344',
    'fechaNacimiento': '05/04/1998',
    'codigoPostal': '20020',
    'ciudad': 'Morelia',
    'pais': 'México',
    'favoritos': '3',
    'reseñas': '8',
    'seguidores': '20',
    'puntos': '300',
    'visitas': '45',
    'sexo': 'Femenino',
    'tieneRestaurante': false, // ✅ No tiene restaurante
  },
  {
    'id': 'U003',
    'nombre': 'Carlos Alberto',
    'apellido': 'Ramírez',
    'username': 'CarlosRam',
    'correo': 'carlos.ramirez@email.com',
    'password': 'abc12345',
    'fechaRegistro': 'Enero 2021',
    'telefono': '5599887766',
    'fechaNacimiento': '20/10/1990',
    'codigoPostal': '30030',
    'ciudad': 'Pátzcuaro',
    'pais': 'México',
    'favoritos': '10',
    'reseñas': '25',
    'seguidores': '15',
    'puntos': '800',
    'visitas': '120',
    'sexo': 'Masculino',
    'tieneRestaurante': true, // ✅ Vinculación con restaurante
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