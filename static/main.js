/**
 * IronTrack — main.js
 * JavaScript global partagé entre toutes les pages.
 * Inclus via : <script src="/static/main.js"></script>
 */

/* ============================================================
   1. FLASH MESSAGES — auto-disparition après 4 secondes
   ============================================================ */
document.addEventListener("DOMContentLoaded", () => {
  const flashes = document.querySelectorAll(".flash");
  flashes.forEach((el) => {
    setTimeout(() => {
      el.style.transition = "opacity .4s ease";
      el.style.opacity = "0";
      setTimeout(() => el.remove(), 400);
    }, 4000);
  });
});

/* ============================================================
   2. NAVIGATION — hamburger menu (mobile)
   ============================================================ */
document.addEventListener("DOMContentLoaded", () => {
  const hamburger = document.getElementById("hamburger");
  const navLinks  = document.getElementById("navLinks");

  if (hamburger && navLinks) {
    hamburger.addEventListener("click", () => {
      navLinks.classList.toggle("open");
    });

    // Fermer le menu en cliquant sur un lien
    navLinks.querySelectorAll("a").forEach((link) => {
      link.addEventListener("click", () => navLinks.classList.remove("open"));
    });
  }
});

/* ============================================================
   3. AVATAR — affiche les initiales du pseudo dans la nav
   ============================================================ */
document.addEventListener("DOMContentLoaded", () => {
  const avatarEl = document.getElementById("nav-avatar");
  if (!avatarEl) return;

  // Le pseudo est injecté par Flask dans un attribut data
  const pseudo = avatarEl.dataset.pseudo || "";
  if (pseudo) {
    avatarEl.textContent = pseudo.slice(0, 2).toUpperCase();
  }
});

/* ============================================================
   4. CALCULATEUR IMC (page index.html)
   ============================================================ */
function calculerIMC() {
  const taille = parseFloat(document.getElementById("taille")?.value);
  const poids  = parseFloat(document.getElementById("poids")?.value);

  if (!taille || !poids || taille < 50 || taille > 250 || poids < 20 || poids > 300) {
    alert("Veuillez entrer une taille (50–250 cm) et un poids (20–300 kg) valides.");
    return;
  }

  const imc = poids / ((taille / 100) ** 2);
  let cat = "";
  if      (imc < 18.5) cat = "Sous-poids";
  else if (imc < 25)   cat = "Poids normal ✓";
  else if (imc < 30)   cat = "Surpoids";
  else                 cat = "Obésité";

  const valEl = document.getElementById("imc-val");
  const catEl = document.getElementById("imc-cat");
  const resEl = document.getElementById("imc-result");

  if (valEl) valEl.textContent = imc.toFixed(2);
  if (catEl) catEl.textContent = cat;
  if (resEl) resEl.classList.add("show");
}

/* ============================================================
   5. CONFIRMATION SUPPRESSION DE COMPTE
   ============================================================ */
document.addEventListener("DOMContentLoaded", () => {
  const deleteForm = document.getElementById("deleteForm");
  if (!deleteForm) return;

  deleteForm.addEventListener("submit", (e) => {
    const confirmed = confirm(
      "⚠️ Êtes-vous certain de vouloir supprimer votre compte ?\n" +
      "Cette action est irréversible et supprimera toutes vos données."
    );
    if (!confirmed) e.preventDefault();
  });
});

/* ============================================================
   6. GRAPHIQUE DE VOLUME (page statistique.html)
      Les données sont injectées par Flask dans data-semaines
   ============================================================ */
document.addEventListener("DOMContentLoaded", () => {
  const chartEl = document.getElementById("chart-bars");
  if (!chartEl) return;

  // Flask injecte les données via un attribut JSON
  let semaines = [];
  try {
    semaines = JSON.parse(chartEl.dataset.semaines || "[]");
  } catch {
    return;
  }

  if (!semaines.length) return;

  const maxVol = Math.max(...semaines.map((s) => s.volume), 1);

  chartEl.innerHTML = semaines
    .map((s) => {
      const pct = Math.round((s.volume / maxVol) * 100);
      return `
        <div class="bar-wrap" title="${s.label} : ${s.volume.toLocaleString()} kg">
          <div class="bar" style="height: ${pct}%" data-val="${s.volume.toLocaleString()} kg"></div>
          <div class="bar-label">${s.label}</div>
        </div>`;
    })
    .join("");
});

/* ============================================================
   7. CALENDRIER (page statistique.html)
      Les jours avec séance sont injectés via data-jours
   ============================================================ */
document.addEventListener("DOMContentLoaded", () => {
  const calEl = document.getElementById("calendar-grid");
  if (!calEl) return;

  let joursAvecSeance = [];
  try {
    joursAvecSeance = JSON.parse(calEl.dataset.jours || "[]");
  } catch {
    return;
  }

  const today    = new Date();
  const annee    = today.getFullYear();
  const mois     = today.getMonth();
  const premierJ = new Date(annee, mois, 1).getDay(); // 0=dim
  const nbJours  = new Date(annee, mois + 1, 0).getDate();

  // Étiquette du mois
  const moisLabel = document.getElementById("calendar-month");
  if (moisLabel) {
    moisLabel.textContent = today.toLocaleDateString("fr-CA", {
      month: "long",
      year: "numeric",
    });
  }

  // Jours vides avant le 1er
  let html = "";
  for (let i = 0; i < premierJ; i++) {
    html += `<div class="cal-day empty"></div>`;
  }

  // Jours du mois
  for (let j = 1; j <= nbJours; j++) {
    const isToday   = j === today.getDate();
    const hasSeance = joursAvecSeance.includes(j);
    const classes   = [
      "cal-day",
      isToday   ? "today"    : "",
      hasSeance ? "has-seance" : "",
    ]
      .filter(Boolean)
      .join(" ");
    html += `<div class="${classes}">${j}</div>`;
  }

  calEl.innerHTML = html;
});