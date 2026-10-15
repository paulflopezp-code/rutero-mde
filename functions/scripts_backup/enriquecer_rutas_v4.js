// enriquecer_rutas_v4.js — ronda final
const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");
admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
const db = admin.firestore();

const DATOS = {
  // Rutas de Feria de las Flores
  'FERIA DE LAS FLORES': {
    subtitulo: 'Flores · Silleteros · Agosto',
    subtituloEN: 'Flowers · Silleteros · August',
    hook: 'La celebración más grande de Medellín — 10 días de flores, música, cabalgatas y el desfile de silleteros más hermoso del mundo.',
    hookEN: 'Medellín\'s biggest celebration — 10 days of flowers, music, parades and the world\'s most beautiful silleta parade.',
    descripcion: 'La Feria de las Flores es la celebración más importante de Medellín: el Desfile de Silleteros, la Cabalgata, el Desfile de Autos Clásicos y decenas de eventos culturales gratuitos durante 10 días en agosto.',
    descripcionEN: 'The Flower Festival is Medellín\'s most important celebration: the Silleta Parade, Cabalgata, Classic Car Parade and dozens of free cultural events during 10 days in August.',
    insigniaImg: 'assets/images/insignias/insignia_feria_silletero_oro.png',
    insignia: 'Silletero de Oro',
  },
  'DESFILE DE SILLETEROS': {
    subtitulo: 'Silleteros · Flores · Tradición',
    subtituloEN: 'Silleteros · Flowers · Tradition',
    hook: 'El desfile más hermoso de Colombia — silleteros que cargan obras de arte floral en sus espaldas por las calles de Medellín.',
    hookEN: 'Colombia\'s most beautiful parade — silleteros carrying floral artworks on their backs through Medellín\'s streets.',
    descripcion: 'El Desfile de Silleteros es el corazón de la Feria de las Flores: 500 silleteros de Santa Elena desfilan con sus creaciones florales por la Avenida El Poblado ante miles de espectadores.',
    descripcionEN: 'The Silleta Parade is the heart of the Flower Festival: 500 silleteros from Santa Elena parade their floral creations along Avenida El Poblado before thousands of spectators.',
    insigniaImg: 'assets/images/insignias/insignia_feria_silletero_oro.png',
    insignia: 'Silletero de Oro',
  },
  'DESFILE DE AUTOS CLÁSICOS Y DE COLECCIÓN': {
    subtitulo: 'Autos · Clásicos · Feria',
    subtituloEN: 'Cars · Classics · Festival',
    hook: 'Los autos más hermosos de Colombia desfilan por Medellín durante la Feria — una exhibición rodante de historia y diseño.',
    hookEN: 'Colombia\'s most beautiful cars parade through Medellín during the Festival — a rolling exhibition of history and design.',
    descripcion: 'El Desfile de Autos Clásicos y de Colección es uno de los eventos más populares de la Feria: cientos de vehículos históricos de todas las épocas recorren las calles de Medellín.',
    descripcionEN: 'The Classic and Collectible Car Parade is one of the Festival\'s most popular events: hundreds of historic vehicles from all eras roll through Medellín\'s streets.',
    insigniaImg: 'assets/images/insignias/insignia_feria_clasica.png',
    insignia: 'Coleccionista Clásico',
  },
  'CABALGATA': {
    subtitulo: 'Caballos · Tradición · Feria',
    subtituloEN: 'Horses · Tradition · Festival',
    hook: 'La Cabalgata de la Feria es el encuentro más grande de caballos y jinetes de Colombia — tradición paisa en su máxima expresión.',
    hookEN: 'The Festival Cabalgata is Colombia\'s largest gathering of horses and riders — paisa tradition at its peak.',
    descripcion: 'La Cabalgata de la Feria de las Flores: miles de jinetes y caballos de paso fino desfilan por el centro de Medellín en uno de los eventos más masivos y coloridos de agosto.',
    descripcionEN: 'The Flower Festival Cabalgata: thousands of riders and paso fino horses parade through downtown Medellín in one of August\'s most massive and colorful events.',
    insigniaImg: 'assets/images/insignias/insignia_10_silletero_honor.png',
    insignia: 'Jinete de Honor',
  },
  'DESFILE DE CHIVAS Y FLORES': {
    subtitulo: 'Chivas · Flores · Alegría',
    subtituloEN: 'Chivas · Flowers · Joy',
    hook: 'Las chivas más alegres de Colombia, decoradas con flores, recorren Medellín durante la Feria — la fiesta rodante más colorida.',
    hookEN: 'Colombia\'s most cheerful chivas, decorated with flowers, tour Medellín during the Festival — the most colorful rolling party.',
    descripcion: 'El Desfile de Chivas y Flores es una de las tradiciones más divertidas de la Feria: los buses típicos colombianos decorados con flores y música animan las calles de Medellín.',
    descripcionEN: 'The Chivas and Flowers Parade is one of the Festival\'s most fun traditions: typical Colombian buses decorated with flowers and music liven up Medellín\'s streets.',
    insigniaImg: 'assets/images/insignias/insignia_feria_silletero_oro.png',
    insignia: 'Viajero de la Chiva',
  },
  'FERIA A RITMO DE BICICLETA': {
    subtitulo: 'Bicicleta · Feria · Medellín',
    subtituloEN: 'Bicycle · Festival · Medellín',
    hook: 'Medellín se toma las calles en bicicleta durante la Feria — el paseo urbano más grande y gratuito del año.',
    hookEN: 'Medellín takes to the streets by bicycle during the Festival — the city\'s largest and free urban ride of the year.',
    descripcion: 'La Feria a Ritmo de Bicicleta es uno de los eventos más masivos de la Feria de las Flores: miles de ciclistas recorren las principales vías de Medellín en un paseo festivo y gratuito.',
    descripcionEN: 'Cycling at the Festival Rhythm is one of the Flower Festival\'s most massive events: thousands of cyclists tour Medellín\'s main roads in a festive, free ride.',
    insigniaImg: 'assets/images/insignias/insignia_12_viajero_tranvia.png',
    insignia: 'Ciclista de la Feria',
  },
  'CONCIERTO INAUGURAL FERIA': {
    subtitulo: 'Música · Inauguración · Feria',
    subtituloEN: 'Music · Inauguration · Festival',
    hook: 'La Feria de las Flores abre con el concierto gratuito más grande de Colombia — artistas internacionales ante cientos de miles.',
    hookEN: 'The Flower Festival opens with Colombia\'s largest free concert — international artists before hundreds of thousands.',
    descripcion: 'El Concierto Inaugural da inicio oficial a la Feria de las Flores: artistas de talla internacional se presentan de forma gratuita ante cientos de miles de personas en el Obelisco de Medellín.',
    descripcionEN: 'The Opening Concert officially kicks off the Flower Festival: internationally renowned artists perform for free before hundreds of thousands at Medellín\'s Obelisk.',
    insigniaImg: 'assets/images/insignias/insignia_feria_clasica.png',
    insignia: 'Asistente Inaugural',
  },
  'DESFILE DE MITOS Y LEYENDAS': {
    subtitulo: 'Mitos · Leyendas · Folklore',
    subtituloEN: 'Myths · Legends · Folklore',
    hook: 'La Patasola, el Mohán y la Llorona toman las calles de Medellín — el desfile más mágico y aterrador de la Feria.',
    hookEN: 'La Patasola, el Mohán and La Llorona take over Medellín\'s streets — the Festival\'s most magical and eerie parade.',
    descripcion: 'El Desfile de Mitos y Leyendas es uno de los eventos más originales de la Feria: personajes del folclor colombiano y latinoamericano desfilan por las calles del centro histórico de Medellín.',
    descripcionEN: 'The Myths and Legends Parade is one of the Festival\'s most original events: characters from Colombian and Latin American folklore parade through Medellín\'s historic center streets.',
    insigniaImg: 'assets/images/insignias/insignia_feria_clasica.png',
    insignia: 'Guardián de los Mitos',
  },
  'DESFILE DE SILLETEROS — VERSIÓN NOCTURNA': {
    subtitulo: 'Silleteros · Noche · Flores',
    subtituloEN: 'Silleteros · Night · Flowers',
    hook: 'Los silleteros de noche — las flores iluminadas y el desfile nocturno más hermoso de la Feria.',
    hookEN: 'Silleteros at night — illuminated flowers and the Festival\'s most beautiful nocturnal parade.',
    descripcion: 'La versión nocturna del Desfile de Silleteros: silleteras iluminadas con luces LED que crean un espectáculo visual único en las noches de la Feria de las Flores.',
    descripcionEN: 'The nocturnal version of the Silleta Parade: LED-lit silleteras create a unique visual spectacle during the Flower Festival nights.',
    insigniaImg: 'assets/images/insignias/insignia_feria_silletero_oro.png',
    insignia: 'Silletero Nocturno',
  },
  'FESTIVAL DE POESÍA': {
    subtitulo: 'Poesía · Literatura · Festival',
    subtituloEN: 'Poetry · Literature · Festival',
    hook: 'El Festival Internacional de Poesía de Medellín es el más importante del mundo — y es completamente gratuito.',
    hookEN: 'Medellín\'s International Poetry Festival is the world\'s most important — and completely free.',
    descripcion: 'El Festival Internacional de Poesía de Medellín reúne cada año a poetas de 50 países en eventos gratuitos por toda la ciudad. Ganó el Right Livelihood Award.',
    descripcionEN: 'Medellín\'s International Poetry Festival gathers poets from 50 countries in free events across the city. It won the Right Livelihood Award.',
    insigniaImg: 'assets/images/insignias/insignia_20_lector_paisa.png',
    insignia: 'Poeta del Festival',
  },
  'FESTIVAL INTERNACIONAL DE TANGO': {
    subtitulo: 'Tango · Gardel · Buenos Aires en MDE',
    subtituloEN: 'Tango · Gardel · Buenos Aires in MDE',
    hook: 'Medellín tiene más tanguerías que cualquier ciudad fuera de Buenos Aires — y el Festival Internacional es la celebración máxima.',
    hookEN: 'Medellín has more tango venues than any city outside Buenos Aires — and the International Festival is the ultimate celebration.',
    descripcion: 'El Festival Internacional de Tango de Medellín rinde homenaje a Carlos Gardel, quien murió en la ciudad en 1935. Milongas, conciertos y espectáculos de tango llenan la ciudad en junio.',
    descripcionEN: 'Medellín\'s International Tango Festival honors Carlos Gardel, who died in the city in 1935. Milongas, concerts and tango shows fill the city in June.',
    insigniaImg: 'assets/images/insignias/insignia_18_gardel_el_medellin.png',
    insignia: 'Alma del Tango',
  },
  'FERIA DE LA ANTIOQUEÑIDAD': {
    subtitulo: 'Tradición · Identidad · Agosto',
    subtituloEN: 'Tradition · Identity · August',
    hook: 'La Antioqueñidad celebra lo más auténtico de la cultura paisa — gastronomía, música y tradiciones de otro tiempo.',
    hookEN: 'Antioqueñidad celebrates the most authentic paisa culture — gastronomy, music and traditions from another era.',
    descripcion: 'La Feria de la Antioqueñidad en agosto: gastronomía paisa, música de carrilera, danza folclórica y los oficios tradicionales que definen la identidad antioqueña.',
    descripcionEN: 'Antioqueñidad Fair in August: paisa gastronomy, carrilera music, folk dance and traditional trades defining Antioquian identity.',
    insigniaImg: 'assets/images/insignias/insignia_06_corazon_paisa.png',
    insignia: 'Corazón Paisa',
  },
  'SEMANA SANTA PATRIMONIAL': {
    subtitulo: 'Fe · Tradición · Procesiones',
    subtituloEN: 'Faith · Tradition · Processions',
    hook: 'La Semana Santa de Medellín es Patrimonio Cultural — procesiones de 400 años que recorren el centro histórico.',
    hookEN: 'Medellín\'s Holy Week is Cultural Heritage — 400-year-old processions through the historic center.',
    descripcion: 'Las procesiones de Semana Santa en el centro histórico de Medellín: una tradición de más de 400 años declarada Patrimonio Cultural que combina fe, arte y devoción popular.',
    descripcionEN: 'Holy Week processions in Medellín\'s historic center: a 400-year-old Cultural Heritage tradition combining faith, art and popular devotion.',
    insigniaImg: 'assets/images/insignias/insignia_16_peregrino_oro.png',
    insignia: 'Peregrino de Oro',
  },
  'RUTA CANDELARIA — BOGOTÁ': {
    subtitulo: 'Colonial · Historia · Arte',
    subtituloEN: 'Colonial · History · Art',
    hook: 'La Candelaria es el corazón histórico de Colombia — museos, universidades y la historia del país en pocas cuadras.',
    hookEN: 'La Candelaria is Colombia\'s historical heart — museums, universities and the country\'s history in just a few blocks.',
    descripcion: 'La Candelaria de Bogotá: el barrio colonial donde nació Colombia. Museos de clase mundial, universidades históricas, arte callejero y la energía cultural más intensa del país.',
    descripcionEN: 'Bogotá\'s La Candelaria: the colonial neighborhood where Colombia was born. World-class museums, historic universities, street art and the country\'s most intense cultural energy.',
    insigniaImg: 'assets/images/insignias/insignia_bta_candelaria.png',
    insignia: 'Explorador de La Candelaria',
  },
  'RUTA CIUDAD BLANCA — POPAYÁN': {
    subtitulo: 'Colonial · Blanca · Gastronomía',
    subtituloEN: 'Colonial · White · Gastronomy',
    hook: 'Popayán, la Ciudad Blanca — 500 años de historia colonial y la gastronomía más premiada de Colombia.',
    hookEN: 'Popayán, the White City — 500 years of colonial history and Colombia\'s most awarded gastronomy.',
    descripcion: 'Popayán la Ciudad Blanca: arquitectura colonial del siglo XVI, Semana Santa Patrimonio de la Humanidad y gastronomía Premio UNESCO Ciudad Creativa.',
    descripcionEN: 'Popayán the White City: 16th century colonial architecture, UNESCO World Heritage Holy Week and UNESCO Creative City of Gastronomy award.',
    insigniaImg: 'assets/images/insignias/insignia_ppn_ciudad_blanca.png',
    insignia: 'Conquistador de Popayán',
  },
};

async function enriquecer() {
  console.log("🚀 Cuarta ronda — ronda final...\n");
  const snapshot = await db.collection("rutas").get();
  let actualizadas = 0, omitidas = 0, sinDatos = 0;

  console.log("📋 Nombres NO encontrados en esta ronda:");
  snapshot.forEach(doc => {
    const d = doc.data();
    const nombre = d.nombre || d.nombreVisible || doc.id;
    if (!DATOS[nombre]) console.log(`   ⚠️  "${nombre}"`);
  });
  console.log("");

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

    if (Object.keys(update).length === 0) { omitidas++; console.log(`⏭️  ${nombre}`); continue; }

    try {
      await doc.ref.update(update);
      actualizadas++;
      console.log(`✅ ${nombre} — ${Object.keys(update).join(', ')}`);
    } catch (e) {
      console.error(`❌ Error en ${nombre}: ${e.message}`);
    }
  }

  console.log(`\n📊 RESUMEN FINAL: ✅ ${actualizadas} · ⏭️ ${omitidas} · ⚠️ ${sinDatos} sin datos`);
  process.exit(0);
}

enriquecer().catch(err => { console.error(err); process.exit(1); });
