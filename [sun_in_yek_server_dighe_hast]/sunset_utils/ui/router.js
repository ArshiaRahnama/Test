const container = document.getElementById('ui-container');
const panelLayer = document.getElementById('panel-layer');
const overlayLayer = document.getElementById('overlay-layer');

const modules = {};

window.addEventListener('message', function (event) {
    const data = event.data;

    if (data.type === 'openUI') {
        const name = data.module;
        const uiType = data.uiType || 'panel';

        if (uiType === 'panel') {
            closePanels();
        }

        if (modules[name]) {
            closeModule(name);
        }

        const iframe = document.createElement('iframe');
        iframe.src = '../modules/' + (data.uiPath || name) + '/ui/index.html';
        iframe.className = 'module-frame ' + uiType;
        iframe.dataset.module = name;
        iframe.dataset.uiType = uiType;

        iframe.onload = function () {
            if (data.payload) {
                iframe.contentWindow.postMessage({
                    type: 'initData',
                    data: data.payload
                }, '*');
            }
        };

        const layer = uiType === 'overlay' ? overlayLayer : panelLayer;
        layer.appendChild(iframe);

        modules[name] = { iframe, uiType };
        container.style.display = 'block';

    } else if (data.type === 'closeUI') {
        if (data.module) {
            closeModule(data.module);
        } else {
            closePanels();
        }

    } else if (data.type === 'closeAllUI') {
        closeAll();

    } else if (data.type === 'sendData') {
        const target = data.module;
        if (target && modules[target]) {
            modules[target].iframe.contentWindow.postMessage({
                type: 'updateData',
                data: data.payload
            }, '*');
        } else {
            // send to all panels if no module specified
            for (const key in modules) {
                if (modules[key].uiType === 'panel') {
                    modules[key].iframe.contentWindow.postMessage({
                        type: 'updateData',
                        data: data.payload
                    }, '*');
                }
            }
        }
    }
});

window.addEventListener('message', function (event) {
    if (!event.data || event.source === window) return;

    if (event.data.type === 'nuiCallback') {
        const moduleName = findModuleBySource(event.source);
        if (!moduleName) return;
        fetch('https://sunset_utils/moduleCallback', {
            method: 'POST',
            body: JSON.stringify({
                module: moduleName,
                action: event.data.action,
                data: event.data.data || {}
            })
        });
    }

    if (event.data.type === 'closeUI') {
        const moduleName = findModuleBySource(event.source);
        if (!moduleName) return;
        fetch('https://sunset_utils/requestClose', {
            method: 'POST',
            body: JSON.stringify({ module: moduleName })
        });
    }
});

document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        const activePanel = getActivePanel();
        if (activePanel) {
            fetch('https://sunset_utils/moduleCallback', {
                method: 'POST',
                body: JSON.stringify({
                    module: activePanel,
                    action: 'escape',
                    data: {}
                })
            });
        }
    }
});

function findModuleBySource(source) {
    for (const name in modules) {
        if (modules[name].iframe.contentWindow === source) {
            return name;
        }
    }
    return null;
}

function getActivePanel() {
    for (const name in modules) {
        if (modules[name].uiType === 'panel') {
            return name;
        }
    }
    return null;
}

function closeModule(name) {
    if (!modules[name]) return;
    modules[name].iframe.remove();
    delete modules[name];
    updateVisibility();
}

function closePanels() {
    for (const name in modules) {
        if (modules[name].uiType === 'panel') {
            modules[name].iframe.remove();
            delete modules[name];
        }
    }
    updateVisibility();
}

function closeAll() {
    for (const name in modules) {
        modules[name].iframe.remove();
        delete modules[name];
    }
    updateVisibility();
}

function updateVisibility() {
    const hasAny = Object.keys(modules).length > 0;
    container.style.display = hasAny ? 'block' : 'none';
}
