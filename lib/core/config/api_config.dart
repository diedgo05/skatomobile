class ApiConfig {
  static const String baseUrl = 'https://skatoweb-orm.onrender.com';

  // Usuarios / Auth
  static const String register = '/users/add';   // POST  {username,email,password,joinDate,idLevelUser}
  static const String login = '/users/login';    // POST  {email,password} -> {message, token}
  static const String me = '/users/me';           // GET   (requiere Bearer token) -> usuario con su id

  // Trucos (el CRUD)
  static const String tricks = '/tricks';                       // GET  todos
  static const String tricksAdd = '/tricks/add';                // POST crear
  static String tricksByUser(int idUser) => '/tricks/$idUser';  // GET  por usuario
  static String tricksUpdate(int id) => '/tricks/up/$id';       // PUT  editar
  static String tricksDelete(int id) => '/tricks/delete/$id';   // DELETE borrar

  // Catálogos (para llenar los dropdowns al crear un truco)
  static const String categories = '/category';     // GET
  static const String difficulties = '/difficulty'; // GET
  static const String levelTricks = '/lt';          // GET
}