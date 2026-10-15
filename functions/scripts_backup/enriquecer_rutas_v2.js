// enriquecer_rutas_v2.js
// Segunda ronda — rutas faltantes del primer script
const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
const db = admin.firestore();

const DATOS = {
  'CAFÉS Y CANTINAS HISTÓRICAS': {
    subtitulo: 'Tradición · Café · Historia',
    subtituloEN: 'Tradition · Coffee · History',
    hook: 'El centro tiene los cafés más históricos de Colombia — recetas de 80 años que no han cambiado.',
    hookEN: 'Downtown has Colombia\'s most historic cafes — 80-year-old recipes unchanged.',
    descripcion: 'Un recorrido por los cafés y cantinas históricas del centro: el Salón Versalles (1942), la Repostería Astor y el Salón Málaga — espacios donde la intelectualidad medellinense debatió por décadas.',
    descripcionEN: 'A tour of downtown\'s historic cafes and taverns: Salón Versalles (1942), Repostería Astor and Salón Málaga — spaces where Medellín\'s intelligentsia debated for decades.',
    insigniaImg: 'assets/images/insignias/insignia_guardian_patrimonio.png',
    insignia: 'Guardián Patrimonial',
  },
  'DISEÑO MODA Y COMPRAS': {
    subtitulo: 'Moda · Diseño · Compras',
    subtituloEN: 'Fashion · Design · Shopping',
    hook: 'Medellín es la capital de la moda en Colombia — y esta ruta te lleva a los mejores destinos de diseño.',
    hookEN: 'Medellín is Colombia\'s fashion capital — and this route takes you to the best design destinations.',
    descripcion: 'La ruta de moda y diseño de Medellín: desde el Centro Comercial Santafé hasta los talleres de diseñadores locales. La ciudad que viste a Colombia y exporta tendencias al mundo.',
    descripcionEN: 'Medellín\'s fashion and design route: from Santafé mall to local designer studios. The city that dresses Colombia and exports trends to the world.',
    insigniaImg: 'assets/images/insignias/insignia_explorador_45.png',
    insignia: 'Explorador de Moda',
  },
  'JOYA COLONIAL OCULTA — CONCEPCIÓN': {
    subtitulo: 'Colonial · Secreto · Historia',
    subtituloEN: 'Colonial · Secret · History',
    hook: 'Pocos saben que existe — un pueblo colonial intacto a 2 horas de Medellín que el turismo masivo no ha descubierto.',
    hookEN: 'Few know it exists — an intact colonial town 2 hours from Medellín that mass tourism hasn\'t discovered.',
    descripcion: 'Concepción es el secreto mejor guardado de Antioquia: un pueblo colonial casi intacto con arquitectura republicana, calles empedradas y una tranquilidad que ya no existe en otros destinos.',
    descripcionEN: 'Concepción is Antioquia\'s best-kept secret: an almost intact colonial town with republican architecture, cobblestone streets and a tranquility that no longer exists elsewhere.',
    insigniaImg: 'assets/images/insignias/insignia_13_guardian_colonial.png',
    insignia: 'Guardián Colonial',
  },
  'MEMORIA Y DERECHOS HUMANOS': {
    subtitulo: 'Memoria · Paz · Derechos',
    subtituloEN: 'Memory · Peace · Rights',
    hook: 'Medellín recuerda para no repetir — una ruta por los lugares que guardan la memoria de las víctimas.',
    hookEN: 'Medellín remembers to not repeat — a route through places that hold victims\' memory.',
    descripcion: 'Un recorrido por los lugares de memoria y derechos humanos de Medellín: museos, monumentos y espacios de reconciliación que honran a las víctimas del conflicto armado.',
    descripcionEN: 'A tour of Medellín\'s memory and human rights places: museums, monuments and reconciliation spaces honoring victims of the armed conflict.',
    insigniaImg: 'assets/images/insignias/insignia_memoria_viva.png',
    insignia: 'Memoria Viva',
  },
  'OTROS CAMINOS EN LAURELES': {
    subtitulo: 'Barrio · Secretos · Gastronomía',
    subtituloEN: 'Neighborhood · Secrets · Gastronomy',
    hook: 'Laureles tiene más rutas que la Avenida 70 — descubrí los rincones que los locales guardan para sí.',
    hookEN: 'Laureles has more routes than Avenida 70 — discover the corners locals keep to themselves.',
    descripcion: 'Los caminos alternativos de Laureles: calles tranquilas, cafeterías de barrio, parques locales y los espacios auténticos de uno de los mejores barrios de Medellín.',
    descripcionEN: 'Laureles\' alternative paths: quiet streets, neighborhood cafes, local parks and the authentic spaces of one of Medellín\'s best neighborhoods.',
    insigniaImg: 'assets/images/insignias/insignia_vecino_laureles.png',
    insignia: 'Vecino de Laureles',
  },
  'RUTA METROCABLE & ARVÍ': {
    subtitulo: 'Cable · Naturaleza · Ecoturismo',
    subtituloEN: 'Cable Car · Nature · Ecotourism',
    hook: 'El metro te lleva a las nubes — el Parque Arví desde el metrocable es la experiencia de naturaleza más increíble de Medellín.',
    hookEN: 'The metro takes you to the clouds — Parque Arví by cable car is Medellín\'s most incredible nature experience.',
    descripcion: 'Metro, metrocable y naturaleza: el recorrido hasta el Parque Arví es una de las experiencias más completas de Medellín. Teleférico sobre los barrios de ladera y bosque nativo en la cima.',
    descripcionEN: 'Metro, cable car and nature: the journey to Parque Arví is one of Medellín\'s most complete experiences. Gondola over hillside neighborhoods and native forest at the summit.',
    insigniaImg: 'assets/images/insignias/insignia_04_viajero_alturas.png',
    insignia: 'Viajero de las Alturas',
  },
  'SABORES DEL CENTRO': {
    subtitulo: 'Gastronomía · Tradición · Historia',
    subtituloEN: 'Gastronomy · Tradition · History',
    hook: 'El centro tiene los sabores más auténticos de Medellín — recetas de 80 años que no han cambiado.',
    hookEN: 'Downtown has Medellín\'s most authentic flavors — 80-year-old recipes unchanged.',
    descripcion: 'La gastronomía histórica del centro: salones de té centenarios, reposterías tradicionales, cantinas de toda la vida y los comedores donde come el Medellín de verdad.',
    descripcionEN: 'Downtown\'s historic gastronomy: century-old tea rooms, traditional bakeries, lifelong taverns and the diners where real Medellín eats.',
    insigniaImg: 'assets/images/insignias/insignia_paladar_paisa.png',
    insignia: 'Paladar del Centro',
  },
  'VIVE EL POBLADO': {
    subtitulo: 'Barrio · Gastronomía · Lifestyle',
    subtituloEN: 'Neighborhood · Gastronomy · Lifestyle',
    hook: 'El Poblado como lo viven los que lo habitan — sin tours, sin filtros, con la autenticidad de su día a día.',
    hookEN: 'El Poblado as its residents experience it — no tours, no filters, with daily life authenticity.',
    descripcion: 'Vivir El Poblado como un local: mercados, cafés de barrio, parques y los rincones cotidianos del barrio más internacional de Medellín.',
    descripcionEN: 'Living El Poblado like a local: markets, neighborhood cafes, parks and everyday corners of Medellín\'s most international neighborhood.',
    insigniaImg: 'assets/images/insignias/insignia_vive_poblado.png',
    insignia: 'Vive el Poblado',
  },
  'VIVE LAURELES': {
    subtitulo: 'Barrio · Parques · Gastronomía',
    subtituloEN: 'Neighborhood · Parks · Gastronomy',
    hook: 'Laureles es el mejor barrio para vivir en Medellín — y esta ruta te muestra por qué.',
    hookEN: 'Laureles is the best neighborhood to live in Medellín — and this route shows you why.',
    descripcion: 'Un día en Laureles como lo viven sus habitantes: parques, mercados de barrio, cafés, gastronomía y el ambiente más humano y tranquilo de la ciudad.',
    descripcionEN: 'A day in Laureles as its residents live it: parks, neighborhood markets, cafes, gastronomy and the city\'s most human and peaceful atmosphere.',
    insigniaImg: 'assets/images/insignias/insignia_vecino_laureles.png',
    insignia: 'Vecino de Laureles',
  },
  // Rutas de temporada
  'FERIA CLÁSICA': {
    subtitulo: 'Feria · Tradición · Agosto',
    subtituloEN: 'Fair · Tradition · August',
    hook: 'La Feria de las Flores tiene una cara clásica que pocos conocen — el Medellín de agosto en su versión más auténtica.',
    hookEN: 'The Flower Festival has a classic face few know — August Medellín in its most authentic version.',
    descripcion: 'Los eventos clásicos de la Feria de las Flores: desfile de silleteros, cabalgata, desfile de autos y los actos que forman la esencia de la celebración más grande de Medellín.',
    descripcionEN: 'Flower Festival classic events: silleta parade, horse parade, car parade and the acts that form the essence of Medellín\'s biggest celebration.',
    insigniaImg: 'assets/images/insignias/insignia_feria_clasica.png',
    insignia: 'Clásico de la Feria',
  },
  'ALUMBRADO NAVIDEÑO': {
    subtitulo: 'Navidad · Luces · Tradición',
    subtituloEN: 'Christmas · Lights · Tradition',
    hook: 'El alumbrado navideño de Medellín es el más famoso de Colombia — millones de luces que transforman la ciudad en diciembre.',
    hookEN: 'Medellín\'s Christmas lights are Colombia\'s most famous — millions of lights transforming the city in December.',
    descripcion: 'El alumbrado navideño de Medellín: el río Medellín transformado en un espectáculo de luces, parques iluminados y la tradición más esperada del año en la ciudad.',
    descripcionEN: 'Medellín\'s Christmas illumination: the Medellín river transformed into a light spectacle, illuminated parks and the city\'s most anticipated annual tradition.',
    insigniaImg: 'assets/images/insignias/insignia_15_guardian_luz_nav.png',
    insignia: 'Guardián de la Luz',
  },
  'SEMANA SANTA PATRIMONIO': {
    subtitulo: 'Fe · Tradición · Procesiones',
    subtituloEN: 'Faith · Tradition · Processions',
    hook: 'La Semana Santa de Medellín es Patrimonio Cultural — procesiones de 400 años que recorren el centro histórico.',
    hookEN: 'Medellín\'s Holy Week is Cultural Heritage — 400-year-old processions through the historic center.',
    descripcion: 'Las procesiones de Semana Santa en el centro histórico de Medellín: una tradición de más de 400 años declarada Patrimonio Cultural que combina fe, arte y devoción popular.',
    descripcionEN: 'Holy Week processions in Medellín\'s historic center: a 400-year-old Cultural Heritage tradition combining faith, art and popular devotion.',
    insigniaImg: 'assets/images/insignias/insignia_16_peregrino_oro.png',
    insignia: 'Peregrino de Oro',
  },
  'MEDEJAZZ': {
    subtitulo: 'Jazz · Música · Festival',
    subtituloEN: 'Jazz · Music · Festival',
    hook: 'Medellín tiene el festival de jazz más importante de Colombia — y los mejores escenarios son gratuitos.',
    hookEN: 'Medellín has Colombia\'s most important jazz festival — and the best stages are free.',
    descripcion: 'El MedejJazz transforma la ciudad cada octubre: conciertos gratuitos en parques y plazas, artistas internacionales y la mejor escena de jazz de Colombia.',
    descripcionEN: 'MedejJazz transforms the city every October: free concerts in parks and plazas, international artists and Colombia\'s best jazz scene.',
    insigniaImg: 'assets/images/insignias/insignia_19_jazz_primavera.png',
    insignia: 'Alma del Jazz',
  },
  'FIESTA DEL LIBRO': {
    subtitulo: 'Literatura · Cultura · Festival',
    subtituloEN: 'Literature · Culture · Festival',
    hook: 'Medellín, ciudad del libro — la Fiesta del Libro más grande de Colombia llega cada año al corazón de la ciudad.',
    hookEN: 'Medellín, city of the book — Colombia\'s largest Book Festival comes to the city\'s heart every year.',
    descripcion: 'La Fiesta del Libro y la Cultura de Medellín: miles de actividades gratuitas, autores internacionales, talleres y el mayor evento literario del país.',
    descripcionEN: 'Medellín\'s Book and Culture Festival: thousands of free activities, international authors, workshops and the country\'s largest literary event.',
    insigniaImg: 'assets/images/insignias/insignia_20_lector_paisa.png',
    insignia: 'Lector Paisa',
  },
  // Rutas otras ciudades
  'RUTA CANDELARIA BOGOTÁ': {
    subtitulo: 'Colonial · Historia · Arte',
    subtituloEN: 'Colonial · History · Art',
    hook: 'La Candelaria es el corazón histórico de Colombia — museos, universidades y la historia del país en pocas cuadras.',
    hookEN: 'La Candelaria is Colombia\'s historical heart — museums, universities and the country\'s history in just a few blocks.',
    descripcion: 'La Candelaria de Bogotá: el barrio colonial donde nació Colombia. Museos de clase mundial, universidades históricas, arte callejero y la energía cultural más intensa del país.',
    descripcionEN: 'Bogotá\'s La Candelaria: the colonial neighborhood where Colombia was born. World-class museums, historic universities, street art and the country\'s most intense cultural energy.',
    insigniaImg: 'assets/images/insignias/insignia_bta_candelaria.png',
    insignia: 'Explorador de La Candelaria',
  },
  'RUTA CIUDAD BLANCA POPAYÁN': {
    subtitulo: 'Colonial · Blanca · Gastronomía',
    subtituloEN: 'Colonial · White · Gastronomy',
    hook: 'Popayán, la Ciudad Blanca — 500 años de historia colonial, la Semana Santa más famosa y la gastronomía más premiada de Colombia.',
    hookEN: 'Popayán, the White City — 500 years of colonial history, Colombia\'s most famous Holy Week and most awarded gastronomy.',
    descripcion: 'Popayán la Ciudad Blanca: arquitectura colonial del siglo XVI, la Semana Santa Patrimonio de la Humanidad y una gastronomía que ganó el Premio UNESCO de Ciudad Creativa.',
    descripcionEN: 'Popayán the White City: 16th century colonial architecture, the UNESCO World Heritage Holy Week and a gastronomy that won the UNESCO Creative City of Gastronomy award.',
    insigniaImg: 'assets/images/insignias/insignia_ppn_ciudad_blanca.png',
    insignia: 'Conquistador de Popayán',
  },
};

async function enriquecer() {
  console.log("🚀 Segunda ronda de enriquecimiento...\n");

  const snapshot = await db.collection("rutas").get();
  let actualizadas = 0;
  let omitidas = 0;
  let sinDatos = 0;

  for (const doc of snapshot.docs) {
    const d = doc.data();
    const nombre = d.nombre || d.nombreVisible || doc.id;
    const datos = DATOS[nombre];

    if (!datos) { sinDatos++; continue; }

    const update = {};
    if ((!d.subtitulo || d.subtitulo.trim() === '') && datos.subtitulo) update.subtitulo = datos.subtitulo;
    if ((!d.subtituloEN || d.subtituloEN.trim() === '') && datos.subtituloEN) update.subtituloEN = datos.subtituloEN;
    if ((!d.hook || d.hook.trim() === '') && datos.hook) update.hook = datos.hook;
    if ((!d.hookEN || d.hookEN.trim() === '') && datos.hookEN) update.hookEN = datos.hookEN;
    if ((!d.descripcion || d.descripcion.trim() === '') && datos.descripcion) update.descripcion = datos.descripcion;
    if ((!d.descripcionEN || d.descripcionEN.trim() === '') && datos.descripcionEN) update.descripcionEN = datos.descripcionEN;
    if ((!d.insigniaImg || d.insigniaImg.trim() === '') && datos.insigniaImg) update.insigniaImg = datos.insigniaImg;
    if ((!d.insignia || d.insignia.trim() === '') && datos.insignia) update.insignia = datos.insignia;

    if (Object.keys(update).length === 0) {
      omitidas++;
      console.log(`⏭️  ${nombre} — ya completa`);
      continue;
    }

    try {
      await doc.ref.update(update);
      actualizadas++;
      console.log(`✅ ${nombre} — ${Object.keys(update).join(', ')}`);
    } catch (e) {
      console.error(`❌ Error en ${nombre}: ${e.message}`);
    }
  }

  console.log(`\n📊 RESUMEN: ✅ ${actualizadas} actualizadas · ⏭️ ${omitidas} completas · ⚠️ ${sinDatos} sin datos`);
  process.exit(0);
}

enriquecer().catch(err => { console.error(err); process.exit(1); });
