// Synthesized chime (Web Audio API) — no bundled audio file needed.
let audioCtx = null;

function getAudioCtx() {
  if (!audioCtx) {
    const AudioContextClass = window.AudioContext || window.webkitAudioContext;
    if (!AudioContextClass) return null;
    audioCtx = new AudioContextClass();
  }
  return audioCtx;
}

function playChime() {
  const ctx = getAudioCtx();
  if (!ctx) return;

  const now = ctx.currentTime;
  const notes = [
    { freq: 880, start: 0,    dur: 0.12 },  // A5
    { freq: 1318.5, start: 0.09, dur: 0.22 }, // E6
  ];

  notes.forEach(note => {
    const osc = ctx.createOscillator();
    const gain = ctx.createGain();
    osc.type = 'sine';
    osc.frequency.value = note.freq;

    gain.gain.setValueAtTime(0, now + note.start);
    gain.gain.linearRampToValueAtTime(0.18, now + note.start + 0.02);
    gain.gain.exponentialRampToValueAtTime(0.0001, now + note.start + note.dur);

    osc.connect(gain);
    gain.connect(ctx.destination);

    osc.start(now + note.start);
    osc.stop(now + note.start + note.dur + 0.05);
  });
}
