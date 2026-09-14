const speedoEl = document.getElementById('speedo');
const valueEl = document.getElementById('speedo-value');
const gearEl = document.getElementById('speedo-gear');
const fuelBarEl = document.getElementById('speedo-fuel-bar');
const engineBarEl = document.getElementById('speedo-engine-bar');

function fuelColor(pct) {
  if (pct <= 15) return '#ff3547';
  if (pct <= 35) return '#ee5253';
  return null; // default gold gradient
}

window.addEventListener('message', function (event) {
  const item = event.data;
  if (!item || !item.action) return;

  if (item.action === 'speedo:show') {
    speedoEl.classList.add('speedo-visible');
  } else if (item.action === 'speedo:hide') {
    speedoEl.classList.remove('speedo-visible');
  } else if (item.action === 'speedo:update') {
    valueEl.textContent = item.speed;
    gearEl.textContent = item.gear === 0 ? 'R' : item.gear;
    fuelBarEl.style.width = item.fuel + '%';
    const customFuelColor = fuelColor(item.fuel);
    fuelBarEl.style.background = customFuelColor ? customFuelColor : '';
    engineBarEl.style.width = item.engine + '%';
    engineBarEl.style.background = item.engine <= 30 ? '#ff3547' : '#33cccc';
  }
});
