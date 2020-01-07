function showService(link) {
  let frame = document.querySelector('#content iframe[name=' + link.target + ']');
  if (!frame.src) frame.src = link.href;

  location.hash = link.name;

  document.querySelectorAll('#menu a.service').forEach(a => {
    let li = a.parentNode;
    li.classList[a == link ? 'add' : 'remove']('current');
  });
  document.querySelectorAll('#content .frame').forEach(frame => {
    frame.classList[frame.name === link.target ? 'add' : 'remove']('current');
  });
}

function reloadCurrent(event) {
  event.preventDefault();
  let frame = document.querySelector('#content .frame.current');
  if (frame) frame.src = frame.src;
}

document.querySelectorAll('#menu a').forEach(a => {
  let reload = document.createElement('a');
  reload.className = 'reload';
  reload.title = 'Reload';
  reload.href = '#';
  reload.innerHTML = '<i class="fas fa-redo-alt"></i>';
  a.parentNode.appendChild(reload);

  a.addEventListener('click', event => {
    event.preventDefault();
    showService(a);
  });

  reload.addEventListener('click', reloadCurrent);
});

// Load the service from hash
let a;
if (location.hash) a = document.querySelector('#menu a[name="' + location.hash.substring(1) + '"]');
if (!a) a = document.querySelector('#menu a');
showService(a);
