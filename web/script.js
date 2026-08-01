// ═══════════════════════════════════════════════════════════
// RUTERO MDE — Landing v2 — script.js
// ═══════════════════════════════════════════════════════════

document.addEventListener('DOMContentLoaded', () => {

  /* ── NAV SCROLL STATE ── */
  const nav = document.getElementById('nav');
  const onScroll = () => {
    if (window.scrollY > 24) nav.classList.add('scrolled');
    else nav.classList.remove('scrolled');
  };
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();

  /* ── LANGUAGE TOGGLE ── */
  const langToggle = document.getElementById('langToggle');
  const langActive = langToggle.querySelector('.lang-active');
  const langInactive = langToggle.querySelector('.lang-inactive');
  const translatable = document.querySelectorAll('[data-es][data-en]');
  let currentLang = 'es';

  function setLang(lang) {
    currentLang = lang;
    const isEN = lang === 'en';
    translatable.forEach(el => {
      el.textContent = isEN ? el.getAttribute('data-en') : el.getAttribute('data-es');
    });
    langActive.textContent = isEN ? 'EN' : 'ES';
    langInactive.textContent = isEN ? 'ES' : 'EN';
    document.documentElement.lang = isEN ? 'en' : 'es';
    try { localStorage.setItem('rutero_lang', lang); } catch(e) {}
  }

  langToggle.addEventListener('click', () => {
    setLang(currentLang === 'en' ? 'es' : 'en');
  });

  // Detect browser language on first visit (no stored preference)
  let storedLang = null;
  try { storedLang = localStorage.getItem('rutero_lang'); } catch(e) {}
  if (storedLang) {
    setLang(storedLang);
  } else {
    const browserLang = (navigator.language || 'es').toLowerCase();
    setLang(browserLang.startsWith('es') ? 'es' : 'en');
  }

  /* ── COUNTDOWN — Feria de las Flores 2026 ── */
  // Target: July 31, 2026, 08:00 COT (UTC-5)
  const feriaStart = new Date('2026-07-31T08:00:00-05:00').getTime();
  const feriaEnd = new Date('2026-08-09T23:59:59-05:00').getTime();

  const cdDays = document.getElementById('cd-days');
  const cdHours = document.getElementById('cd-hours');
  const cdMins = document.getElementById('cd-mins');
  const cdSecs = document.getElementById('cd-secs');

  function updateCountdown() {
    const now = Date.now();
    let diff;
    let label = null;

    if (now < feriaStart) {
      diff = feriaStart - now;
    } else if (now >= feriaStart && now <= feriaEnd) {
      diff = feriaEnd - now;
      label = 'live';
    } else {
      // Festival ended — show static message
      if (cdDays) cdDays.textContent = '🌺';
      if (cdHours) cdHours.parentElement.style.display = 'none';
      if (cdMins) cdMins.parentElement.style.display = 'none';
      if (cdSecs) cdSecs.parentElement.style.display = 'none';
      return;
    }

    const days = Math.floor(diff / (1000 * 60 * 60 * 24));
    const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const mins = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
    const secs = Math.floor((diff % (1000 * 60)) / 1000);

    if (cdDays) cdDays.textContent = String(days).padStart(2, '0');
    if (cdHours) cdHours.textContent = String(hours).padStart(2, '0');
    if (cdMins) cdMins.textContent = String(mins).padStart(2, '0');
    if (cdSecs) cdSecs.textContent = String(secs).padStart(2, '0');
  }

  if (cdDays) {
    updateCountdown();
    setInterval(updateCountdown, 1000);
  }

  /* ── SCROLL REVEAL ── */
  const revealTargets = document.querySelectorAll(
    '.city-card, .how-step, .badge-item, .feria-route-card'
  );
  revealTargets.forEach(el => el.classList.add('reveal'));

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('in-view');
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.15, rootMargin: '0px 0px -40px 0px' });

  revealTargets.forEach(el => observer.observe(el));

  /* ── SMOOTH ANCHOR OFFSET (account for fixed nav) ── */
  document.querySelectorAll('a[href^="#"]').forEach(link => {
    link.addEventListener('click', (e) => {
      const id = link.getAttribute('href');
      if (id.length <= 1) return;
      const target = document.querySelector(id);
      if (!target) return;
      e.preventDefault();
      const navHeight = nav.offsetHeight;
      const top = target.getBoundingClientRect().top + window.scrollY - navHeight - 12;
      window.scrollTo({ top, behavior: 'smooth' });
    });
  });

});
