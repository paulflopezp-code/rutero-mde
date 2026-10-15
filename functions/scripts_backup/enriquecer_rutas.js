// enriquecer_rutas.js
// Completa campos vacíos en rutas de Firestore — hook, descripcion, subtitulo, insigniaImg
const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
const db = admin.firestore();

// ── Datos de enriquecimiento por ruta ─────────────────────────────────────────
const DATOS = {
  'BARRIO PRADO — CULTURA Y BOHEMIA': {
    subtitulo: 'Bohemia · Arte · Historia',
    subtituloEN: 'Bohemia · Art · History',
    hook: 'El barrio más bohemio de Medellín te espera — casas republicanas, galerías de arte y el ambiente más auténtico del centro.',
    hookEN: 'Medellín\'s most bohemian neighborhood awaits — republican houses, art galleries and the most authentic downtown atmosphere.',
    descripcion: 'Barrio Prado es el corazón cultural del centro de Medellín. Casas republicanas de los años 30, galerías de arte alternativo, teatros comunitarios y la escena cultural más activa de la ciudad.',
    descripcionEN: 'Barrio Prado is the cultural heart of downtown Medellín. 1930s republican houses, alternative art galleries, community theaters and the city\'s most active cultural scene.',
    insigniaImg: 'assets/images/insignias/insignia_bohemia_centro.png',
    insignia: 'Bohemio del Prado',
  },
  'CENTRO ALTERNATIVO': {
    subtitulo: 'Arte · Contracultura · Historia',
    subtituloEN: 'Art · Counterculture · History',
    hook: 'El centro que no ves en los tours — el Medellín auténtico, alternativo y rebelde que pocos turistas conocen.',
    hookEN: 'The downtown you don\'t see on tours — the authentic, alternative and rebellious Medellín few tourists know.',
    descripcion: 'Una ruta por el corazón alternativo del centro histórico — parques bohemios, librerías anticuarias, cantinas centenarias y los espacios donde nació la contracultura medellinense.',
    descripcionEN: 'A route through the alternative heart of the historic center — bohemian parks, antiquarian bookshops, century-old taverns and the spaces where Medellín\'s counterculture was born.',
    insigniaImg: 'assets/images/insignias/insignia_explorador_oculto.png',
    insignia: 'Explorador Oculto',
  },
  'DEL ORIGEN PAISA A LA MEDELLÍN MODERNA': {
    subtitulo: 'Historia · Transformación · Identidad',
    subtituloEN: 'History · Transformation · Identity',
    hook: 'De pueblo minero a metrópolis — la historia completa de Medellín en una sola ruta.',
    hookEN: 'From mining town to metropolis — the complete history of Medellín in a single route.',
    descripcion: 'Un recorrido por la historia de Medellín: del origen paisa del siglo XVII a la ciudad innovadora del siglo XXI. Museos, plazas históricas y los hitos que forjaron la identidad antioqueña.',
    descripcionEN: 'A journey through Medellín\'s history: from its 17th century paisa origins to the 21st century innovative city. Museums, historic plazas and the milestones that forged Antioquian identity.',
    insigniaImg: 'assets/images/insignias/insignia_11_embajador_paisa_moderno.png',
    insignia: 'Embajador Paisa Moderno',
  },
  'EL POBLADO CREATIVO': {
    subtitulo: 'Arte · Diseño · Gastronomía',
    subtituloEN: 'Art · Design · Gastronomy',
    hook: 'El Poblado más allá de los bares — galerías, talleres de diseño y la escena creativa que pocos conocen.',
    hookEN: 'El Poblado beyond the bars — galleries, design studios and the creative scene few people know.',
    descripcion: 'La cara creativa de El Poblado: galerías de arte contemporáneo, talleres de diseño, restaurantes de autor y los espacios donde nació la industria creativa de Medellín.',
    descripcionEN: 'El Poblado\'s creative face: contemporary art galleries, design studios, chef restaurants and the spaces where Medellín\'s creative industry was born.',
    insigniaImg: 'assets/images/insignias/insignia_espiritu_creativo.png',
    insignia: 'Espíritu Creativo',
  },
  'EL POBLADO VERDE': {
    subtitulo: 'Naturaleza · Parques · Bienestar',
    subtituloEN: 'Nature · Parks · Wellness',
    hook: 'El Poblado tiene un secreto verde — parques escondidos, jardines y senderos que los turistas nunca encuentran.',
    hookEN: 'El Poblado has a green secret — hidden parks, gardens and trails tourists never find.',
    descripcion: 'Los espacios verdes de El Poblado: parques escondidos, jardines comunitarios y senderos urbanos que contrastan con la ciudad de concreto. Una ruta de bienestar en el corazón del barrio.',
    descripcionEN: 'El Poblado\'s green spaces: hidden parks, community gardens and urban trails that contrast with the concrete city. A wellness route in the heart of the neighborhood.',
    insigniaImg: 'assets/images/insignias/insignia_poblado_verde.png',
    insignia: 'Guardián Verde',
  },
  'ENTRE JUEGOS Y PALABRAS': {
    subtitulo: 'Cultura · Lectura · Juegos',
    subtituloEN: 'Culture · Reading · Games',
    hook: 'Laureles tiene una tradición cultural que va más allá de los restaurantes — libros, juegos y comunidad.',
    hookEN: 'Laureles has a cultural tradition beyond restaurants — books, games and community.',
    descripcion: 'Un recorrido por los espacios de cultura popular de Laureles: librerías de viejo, ludotecas, parques de ajedrez y los lugares donde la comunidad se reúne a compartir.',
    descripcionEN: 'A tour of Laureles\' popular culture spaces: used bookstores, game rooms, chess parks and the places where the community gathers to share.',
    insigniaImg: 'assets/images/insignias/insignia_vecino_laureles.png',
    insignia: 'Vecino Cultural',
  },
  'ENTRE SABORES RISAS Y MIL COLORES': {
    subtitulo: 'Gastronomía · Arte · Rumba',
    subtituloEN: 'Gastronomy · Art · Nightlife',
    hook: 'La ruta más emocionante y colorida de Medellín — 5 experiencias en 5 zonas distintas de la ciudad.',
    hookEN: 'Medellín\'s most exciting and colorful route — 5 experiences in 5 different city zones.',
    descripcion: 'Una aventura gastronómica y cultural que recorre 5 zonas distintas de Medellín — desde el Poblado hasta San Cristóbal. Cada parada es un mundo diferente.',
    descripcionEN: 'A gastronomic and cultural adventure across 5 different zones of Medellín — from El Poblado to San Cristóbal. Each stop is a different world.',
    insigniaImg: 'assets/images/insignias/insignia_paladar_paisa.png',
    insignia: 'Paladar Paisa',
  },
  'HUELLAS VIVAS DE EL POBLADO': {
    subtitulo: 'Historia · Patrimonio · Arquitectura',
    subtituloEN: 'History · Heritage · Architecture',
    hook: 'El Poblado que existía antes de los bares — historia, patrimonio y las huellas que aún quedan de otro tiempo.',
    hookEN: 'The El Poblado that existed before the bars — history, heritage and the traces that remain from another era.',
    descripcion: 'Un recorrido por el El Poblado histórico: desde su fundación en 1616 hasta los vestigios republicanos que sobrevivieron al boom inmobiliario. Patrimonio vivo en el barrio más cambiado de Medellín.',
    descripcionEN: 'A tour of historic El Poblado: from its 1616 founding to the republican vestiges that survived the real estate boom. Living heritage in Medellín\'s most changed neighborhood.',
    insigniaImg: 'assets/images/insignias/insignia_huellas_vivas.png',
    insignia: 'Guardián del Patrimonio',
  },
  'MANRIQUE CULTURA Y VIDA': {
    subtitulo: 'Comunidad · Arte · Transformación',
    subtituloEN: 'Community · Art · Transformation',
    hook: 'Manrique no es solo el metro — es un barrio vivo, con murales, mercados y una comunidad que transformó su historia.',
    hookEN: 'Manrique is more than the metro — it\'s a living neighborhood with murals, markets and a community that transformed its history.',
    descripcion: 'Un recorrido por el Manrique cultural: escaleras eléctricas, murales comunitarios, mercados populares y los espacios de arte que transformaron uno de los barrios más resilientes de Medellín.',
    descripcionEN: 'A tour of cultural Manrique: electric escalators, community murals, popular markets and the art spaces that transformed one of Medellín\'s most resilient neighborhoods.',
    insigniaImg: 'assets/images/insignias/insignia_explorador_45.png',
    insignia: 'Explorador de Barrios',
  },
  'NOCHE EN EL POBLADO': {
    subtitulo: 'Gastronomía · Bares · Música',
    subtituloEN: 'Gastronomy · Bars · Music',
    hook: 'La noche de El Poblado es una leyenda — pero hay una versión más auténtica que los turistas nunca ven.',
    hookEN: 'El Poblado\'s nightlife is legendary — but there\'s a more authentic version tourists never see.',
    descripcion: 'La guía definitiva para la noche de El Poblado: desde los bares de cocteles craft hasta los restaurantes de chef, pasando por los rincones bohemios que los locales frecuentan.',
    descripcionEN: 'The definitive guide to El Poblado\'s nightlife: from craft cocktail bars to chef restaurants, through the bohemian corners that locals frequent.',
    insigniaImg: 'assets/images/insignias/insignia_noctambulo_paisa.png',
    insignia: 'Noctámbulo Paisa',
  },
  'NOCHE EN LAURELES': {
    subtitulo: 'Bares · Gastronomía · Ambiente Barrial',
    subtituloEN: 'Bars · Gastronomy · Neighborhood Vibe',
    hook: 'La noche más auténtica de Medellín no está en El Poblado — está en Laureles.',
    hookEN: 'Medellín\'s most authentic nightlife isn\'t in El Poblado — it\'s in Laureles.',
    descripcion: 'Laureles de noche: el Segundo Parque como epicentro, la Avenida 70 gastronómica y los bares donde se mezclan locales y viajeros en el ambiente más barrial de la ciudad.',
    descripcionEN: 'Laureles at night: Segundo Parque as epicenter, the gastronomic Avenida 70 and the bars where locals and travelers mix in the city\'s most neighborhood atmosphere.',
    insigniaImg: 'assets/images/insignias/insignia_noctambulo_paisa.png',
    insignia: 'Noctámbulo Paisa',
  },
  'OTROS CAMINOS EN LAURELES': {
    subtitulo: 'Barrio · Gastronomía · Cultura',
    subtituloEN: 'Neighborhood · Gastronomy · Culture',
    hook: 'Laureles tiene más rutas que la Avenida 70 — descubrí los rincones que los locales guardan para sí.',
    hookEN: 'Laureles has more routes than Avenida 70 — discover the corners locals keep to themselves.',
    descripcion: 'Los caminos alternativos de Laureles: calles tranquilas, cafeterías de barrio, parques locales y los espacios auténticos de uno de los mejores barrios para vivir en Medellín.',
    descripcionEN: 'Laureles\' alternative paths: quiet streets, neighborhood cafes, local parks and the authentic spaces of one of Medellín\'s best neighborhoods to live in.',
    insigniaImg: 'assets/images/insignias/insignia_vecino_laureles.png',
    insignia: 'Vecino de Laureles',
  },
  'RINCONES ESCONDIDOS DE EL POBLADO': {
    subtitulo: 'Secretos · Arte · Arquitectura',
    subtituloEN: 'Secrets · Art · Architecture',
    hook: 'El Poblado tiene rincones que ni los turistas ni los expats conocen — sanctuarios, fábricas y parques ocultos.',
    hookEN: 'El Poblado has corners that neither tourists nor expats know — sanctuaries, factories and hidden parks.',
    descripcion: 'Los rincones menos conocidos de El Poblado: Manila republicana, fábricas artesanales, parques escondidos y santuarios que sobrevivieron entre los edificios de lujo.',
    descripcionEN: 'El Poblado\'s least known corners: republican Manila, artisan factories, hidden parks and sanctuaries that survived among luxury buildings.',
    insigniaImg: 'assets/images/insignias/insignia_explorador_oculto.png',
    insignia: 'Explorador Oculto',
  },
  'SABORES DE EL POBLADO': {
    subtitulo: 'Gastronomía · Chef · Experiencias',
    subtituloEN: 'Gastronomy · Chef · Experiences',
    hook: 'El Poblado tiene la mejor oferta gastronómica de Medellín — pero hay que saber dónde ir.',
    hookEN: 'El Poblado has Medellín\'s best gastronomic offer — but you have to know where to go.',
    descripcion: 'Los mejores sabores de El Poblado: desde restaurantes de chef hasta mercados artesanales, cocteles craft y postres que se han vuelto referentes de la gastronomía medellinense.',
    descripcionEN: 'El Poblado\'s best flavors: from chef restaurants to artisan markets, craft cocktails and desserts that have become benchmarks of Medellín gastronomy.',
    insigniaImg: 'assets/images/insignias/insignia_paladar_paisa.png',
    insignia: 'Paladar Gourmet',
  },
  'SABORES DE LA 70': {
    subtitulo: 'Gastronomía · Calle · Diversidad',
    subtituloEN: 'Gastronomy · Street · Diversity',
    hook: 'La Avenida 70 tiene más de 80 restaurantes en 6 cuadras — el corredor gastronómico más diverso de Medellín.',
    hookEN: 'Avenida 70 has over 80 restaurants in 6 blocks — Medellín\'s most diverse gastronomic corridor.',
    descripcion: 'Un recorrido por la Avenida 70 y sus alrededores: cocina paisa tradicional, restaurantes internacionales, bares de moda y los puestos callejeros que hacen de este corredor el más vibrante de la ciudad.',
    descripcionEN: 'A tour of Avenida 70 and surroundings: traditional paisa cuisine, international restaurants, trendy bars and street food stalls that make this corridor the most vibrant in the city.',
    insigniaImg: 'assets/images/insignias/insignia_paladar_70.png',
    insignia: 'Paladar de la 70',
  },
  'SABORES DEL CENTRO': {
    subtitulo: 'Gastronomía · Tradición · Historia',
    subtituloEN: 'Gastronomy · Tradition · History',
    hook: 'El centro tiene los sabores más auténticos de Medellín — recetas de 80 años que no han cambiado.',
    hookEN: 'Downtown has Medellín\'s most authentic flavors — 80-year-old recipes that haven\'t changed.',
    descripcion: 'La gastronomía histórica del centro: salones de té centenarios, reposterías tradicionales, cantinas de toda la vida y los comedores donde come el Medellín de verdad.',
    descripcionEN: 'Downtown\'s historic gastronomy: century-old tea rooms, traditional bakeries, lifelong taverns and the diners where real Medellín eats.',
    insigniaImg: 'assets/images/insignias/insignia_paladar_paisa.png',
    insignia: 'Paladar del Centro',
  },
  'TEATROS Y ESCENA DEL CENTRO': {
    subtitulo: 'Teatro · Música · Cultura',
    subtituloEN: 'Theater · Music · Culture',
    hook: 'El centro de Medellín tiene más teatros por cuadra que cualquier otro barrio — la escena cultural más rica de la ciudad.',
    hookEN: 'Downtown Medellín has more theaters per block than any other neighborhood — the city\'s richest cultural scene.',
    descripcion: 'Un recorrido por la escena cultural del centro histórico: teatros centenarios, espacios de danza, salas de música en vivo y los lugares donde nació la tradición escénica de Medellín.',
    descripcionEN: 'A tour of the historic center\'s cultural scene: century-old theaters, dance spaces, live music venues and the places where Medellín\'s performance tradition was born.',
    insigniaImg: 'assets/images/insignias/insignia_guardian_patrimonio.png',
    insignia: 'Guardián Cultural',
  },
  'TRANSFORMACIÓN MEMORIA E HISTORIA': {
    subtitulo: 'Memoria · Resiliencia · Futuro',
    subtituloEN: 'Memory · Resilience · Future',
    hook: 'Medellín pasó de ser la ciudad más violenta del mundo a un ejemplo global — esta ruta cuenta esa historia.',
    hookEN: 'Medellín went from the world\'s most violent city to a global example — this route tells that story.',
    descripcion: 'Un recorrido por la transformación de Medellín: desde los sitios de memoria de la violencia hasta los espacios de innovación urbana. La historia de resiliencia más increíble de América Latina.',
    descripcionEN: 'A tour of Medellín\'s transformation: from violence memory sites to urban innovation spaces. Latin America\'s most incredible resilience story.',
    insigniaImg: 'assets/images/insignias/insignia_memoria_viva.png',
    insignia: 'Memoria Viva',
  },
  'TRANVÍA CULTURAL': {
    subtitulo: 'Tranvía · Arte · Historia',
    subtituloEN: 'Tram · Art · History',
    hook: 'El tranvía que volvió después de 70 años — un viaje por arte, historia y los barrios del oriente de Medellín.',
    hookEN: 'The tram that returned after 70 years — a journey through art, history and Medellín\'s eastern neighborhoods.',
    descripcion: 'Un recorrido en el Tranvía de Ayacucho desde el Parque San Antonio hasta la Placita de Flórez — 2.3 km de arte callejero, historia barrial y la reconexión del centro con las laderas orientales.',
    descripcionEN: 'A tram journey from Parque San Antonio to Placita de Flórez — 2.3 km of street art, neighborhood history and the reconnection of downtown with the eastern hillsides.',
    insigniaImg: 'assets/images/insignias/insignia_12_viajero_tranvia.png',
    insignia: 'Viajero del Tranvía',
  },
  'TURISMO CREATIVO': {
    subtitulo: 'Arte · Danza · Experiencias',
    subtituloEN: 'Art · Dance · Experiences',
    hook: 'Medellín tiene una escena creativa que va mucho más allá del street art — esta ruta te lleva a vivirla.',
    hookEN: 'Medellín has a creative scene that goes far beyond street art — this route takes you to experience it.',
    descripcion: 'Cinco experiencias creativas únicas en Medellín: danza, artes visuales, música, gastronomía de autor y cultura popular. Un recorrido por la ciudad que inspira.',
    descripcionEN: 'Five unique creative experiences in Medellín: dance, visual arts, music, chef gastronomy and popular culture. A tour of the inspiring city.',
    insigniaImg: 'assets/images/insignias/insignia_espiritu_creativo.png',
    insignia: 'Espíritu Creativo',
  },
  'VIVE EL POBLADO': {
    subtitulo: 'Barrio · Gastronomía · Lifestyle',
    subtituloEN: 'Neighborhood · Gastronomy · Lifestyle',
    hook: 'El Poblado como lo viven los que lo habitan — sin tours, sin filtros, con la autenticidad de su día a día.',
    hookEN: 'El Poblado as its residents experience it — no tours, no filters, with the authenticity of daily life.',
    descripcion: 'Vivir El Poblado como un local: mercados, cafés de barrio, parques y los rincones cotidianos del barrio más internacional de Medellín.',
    descripcionEN: 'Living El Poblado like a local: markets, neighborhood cafes, parks and the everyday corners of Medellín\'s most international neighborhood.',
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
  'VIVE MANRIQUE': {
    subtitulo: 'Comunidad · Murales · Escaleras',
    subtituloEN: 'Community · Murals · Escalators',
    hook: 'Manrique es el símbolo de la transformación urbana de Medellín — vívelo desde adentro.',
    hookEN: 'Manrique is the symbol of Medellín\'s urban transformation — experience it from the inside.',
    descripcion: 'Manrique más allá de las escaleras eléctricas: murales comunitarios, mercados populares, arte callejero y la historia de un barrio que se reinventó a sí mismo.',
    descripcionEN: 'Manrique beyond the escalators: community murals, popular markets, street art and the story of a neighborhood that reinvented itself.',
    insigniaImg: 'assets/images/insignias/insignia_explorador_45.png',
    insignia: 'Explorador de Manrique',
  },
  'RUTA GUATAPÉ & LA PIEDRA': {
    subtitulo: 'Aventura · Embalse · Zócalos',
    subtituloEN: 'Adventure · Reservoir · Zócalos',
    hook: 'Medellín tiene un secreto a 2 horas: un lago azul, un monolito de 220 millones de años y un pueblo que tuvo que hundirse para dar luz al país.',
    hookEN: 'Medellín has a secret 2 hours away: a blue lake, a 220-million-year-old monolith and a town that had to sink to power a nation.',
    descripcion: 'La ruta de aventura más épica desde Medellín: 740 escalones hasta la cima de La Piedra, embalse turquesa, zócalos de colores y la historia del pueblo que fue inundado para generar energía.',
    descripcionEN: 'The most epic adventure route from Medellín: 740 steps to the top of La Piedra, turquoise reservoir, colorful zócalos and the story of the town flooded to generate energy.',
    insigniaImg: 'assets/images/insignias/insignia_conquistador_piedra.png',
    insignia: 'Conquistador del Peñol',
  },
  'RUTA SANTA FE DE ANTIOQUIA': {
    subtitulo: 'Colonial · Historia · Arquitectura',
    subtituloEN: 'Colonial · History · Architecture',
    hook: 'A 2 horas de Medellín existe una ciudad que el tiempo olvidó — empedradas, casonas y el mejor tamal del mundo.',
    hookEN: '2 hours from Medellín exists a city time forgot — cobblestones, colonial mansions and the world\'s best tamal.',
    descripcion: 'Santa Fe de Antioquia: la antigua capital de Antioquia conserva sus calles coloniales, iglesias del siglo XVII y la gastronomía más auténtica de la región.',
    descripcionEN: 'Santa Fe de Antioquia: Antioquia\'s former capital preserves its colonial streets, 17th century churches and the region\'s most authentic gastronomy.',
    insigniaImg: 'assets/images/insignias/insignia_13_guardian_colonial.png',
    insignia: 'Guardián Colonial',
  },
  'FINCAS AGROTURÍSTICAS': {
    subtitulo: 'Campo · Naturaleza · Agricultura',
    subtituloEN: 'Countryside · Nature · Agriculture',
    hook: 'A menos de una hora de Medellín, las fincas cafeteras y agroturísticas guardan la esencia paisa más auténtica.',
    hookEN: 'Less than an hour from Medellín, coffee and agrotourism farms hold the most authentic paisa essence.',
    descripcion: 'Un día en las fincas agroturísticas de los alrededores de Medellín: café de origen, gastronomía campesina, naturaleza y la vida del campo antioqueño a pocos kilómetros de la ciudad.',
    descripcionEN: 'A day at agrotourism farms around Medellín: origin coffee, peasant gastronomy, nature and Antioquian country life just kilometers from the city.',
    insigniaImg: 'assets/images/insignias/insignia_03_guardabosque.png',
    insignia: 'Guardabosque',
  },
  'FINCAS SILLETERAS': {
    subtitulo: 'Flores · Tradición · Silleteros',
    subtituloEN: 'Flowers · Tradition · Silleteros',
    hook: 'Las flores de la Feria de las Flores nacen aquí — en las fincas silleteras de Santa Elena.',
    hookEN: 'The flowers of the Flower Festival are born here — in the silleta farms of Santa Elena.',
    descripcion: 'Un recorrido por las fincas silleteras de Santa Elena: el origen de la tradición más bella de Medellín. Conoce a los artesanos que crean las silleteras que desfilan cada agosto.',
    descripcionEN: 'A tour of Santa Elena\'s silleta farms: the origin of Medellín\'s most beautiful tradition. Meet the craftspeople who create the silleteras that parade every August.',
    insigniaImg: 'assets/images/insignias/insignia_guardian_silletero.png',
    insignia: 'Guardián Silletero',
  },
  'JOYA COLONIAL OCULTA — CONCEPCIÓN': {
    subtitulo: 'Colonial · Secreto · Historia',
    subtituloEN: 'Colonial · Secret · History',
    hook: 'Pocos saben que existe — un pueblo colonial intacto a 2 horas de Medellín que el turismo masivo no ha descubierto.',
    hookEN: 'Few know it exists — an intact colonial town 2 hours from Medellín that mass tourism hasn\'t discovered.',
    descripcion: 'Concepción es el secreto mejor guardado de Antioquia: un pueblo colonial casi intacto con arquitectura republicana, calles empedradas y una tranquilidad que ya no existe en otros destinos.',
    descripcionEN: 'Concepción is Antioquia\'s best-kept secret: an almost intact colonial town with republican architecture, cobblestone streets and a tranquility that no longer exists in other destinations.',
    insigniaImg: 'assets/images/insignias/insignia_13_guardian_colonial.png',
    insignia: 'Guardián Colonial',
  },
  'RUTA DE LOS MIRADORES': {
    subtitulo: 'Vistas · Fotografía · Naturaleza',
    subtituloEN: 'Views · Photography · Nature',
    hook: 'Medellín vista desde arriba es otra ciudad — miradores secretos, atardeceres épicos y la mejor foto de tu viaje.',
    hookEN: 'Medellín seen from above is a different city — secret viewpoints, epic sunsets and the best photo of your trip.',
    descripcion: 'Los mejores miradores de Medellín: desde los cerros orientales hasta las terrazas del centro. Vistas panorámicas de la ciudad del eterno verano desde sus puntos más altos.',
    descripcionEN: 'Medellín\'s best viewpoints: from the eastern hills to downtown terraces. Panoramic views of the city of eternal spring from its highest points.',
    insigniaImg: 'assets/images/insignias/insignia_07_condor_andes.png',
    insignia: 'Cóndor de los Andes',
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
  'RUTA VERDE DEL NORTE': {
    subtitulo: 'Naturaleza · Senderismo · Ecoturismo',
    subtituloEN: 'Nature · Hiking · Ecotourism',
    hook: 'El norte de Medellín guarda los últimos bosques urbanos de la ciudad — una aventura verde a minutos del centro.',
    hookEN: 'Northern Medellín holds the city\'s last urban forests — a green adventure minutes from downtown.',
    descripcion: 'Los espacios verdes del norte de Medellín: jardín botánico, parques lineales, cerros naturales y los ecosistemas que sobrevivieron en medio de la ciudad.',
    descripcionEN: 'Northern Medellín\'s green spaces: botanical garden, linear parks, natural hills and the ecosystems that survived within the city.',
    insigniaImg: 'assets/images/insignias/insignia_03_guardabosque.png',
    insignia: 'Guardabosque',
  },
  'SENDEROS EN FLOR': {
    subtitulo: 'Flores · Silleteros · Santa Elena',
    subtituloEN: 'Flowers · Silleteros · Santa Elena',
    hook: 'Santa Elena en flor — los senderos donde nacen las flores que desfilan cada agosto en la Feria.',
    hookEN: 'Santa Elena in bloom — the trails where the flowers that parade every August at the Festival are born.',
    descripcion: 'Los senderos floridos de Santa Elena: caminatas entre jardines, fincas silleteras y la naturaleza que rodea a Medellín. El origen vegetal de la tradición más bella de la ciudad.',
    descripcionEN: 'Santa Elena\'s flowery trails: walks through gardens, silleta farms and the nature surrounding Medellín. The botanical origin of the city\'s most beautiful tradition.',
    insigniaImg: 'assets/images/insignias/insignia_guardian_silletero.png',
    insignia: 'Guardián Silletero',
  },
  'VEREDAS DE SANTA ELENA': {
    subtitulo: 'Campo · Tradición · Silleteros',
    subtituloEN: 'Countryside · Tradition · Silleteros',
    hook: 'Las veredas de Santa Elena son el alma campesina de Medellín — flores, tamales y silleteros en su hábitat natural.',
    hookEN: 'Santa Elena\'s veredas are Medellín\'s peasant soul — flowers, tamales and silleteros in their natural habitat.',
    descripcion: 'Un recorrido auténtico por las veredas de Santa Elena: comunidades campesinas, fincas tradicionales, gastronomía paisa y la cultura silletera que define la identidad de Medellín.',
    descripcionEN: 'An authentic tour of Santa Elena\'s rural communities: peasant communities, traditional farms, paisa gastronomy and the silleta culture that defines Medellín\'s identity.',
    insigniaImg: 'assets/images/insignias/insignia_guardian_silletero.png',
    insignia: 'Guardián Silletero',
  },
};

// ── Script principal ───────────────────────────────────────────────────────────
async function enriquecer() {
  console.log("🚀 Iniciando enriquecimiento masivo de rutas...\n");

  const snapshot = await db.collection("rutas").get();
  let actualizadas = 0;
  let omitidas = 0;
  let sinDatos = 0;

  for (const doc of snapshot.docs) {
    const d = doc.data();
    const nombre = d.nombre || d.nombreVisible || doc.id;
    const datos = DATOS[nombre];

    if (!datos) {
      sinDatos++;
      continue;
    }

    // Solo actualizar campos que estén vacíos
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
      console.log(`✅ ${nombre}`);
      console.log(`   Campos actualizados: ${Object.keys(update).join(', ')}`);
    } catch (e) {
      console.error(`❌ Error en ${nombre}: ${e.message}`);
    }
  }

  console.log(`\n📊 RESUMEN:`);
  console.log(`   ✅ Actualizadas: ${actualizadas}`);
  console.log(`   ⏭️  Ya completas: ${omitidas}`);
  console.log(`   ⚠️  Sin datos en script: ${sinDatos}`);
  process.exit(0);
}

enriquecer().catch(err => {
  console.error("Error:", err);
  process.exit(1);
});
