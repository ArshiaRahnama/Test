-- ------------------------------------------------------------
-- PAINEL ADMIN: definicoes do telemovel que o painel pode mudar (lista branca, 2026-10-03)
-- Cada linha e um caminho dentro de Config. O servidor so aceita estes caminhos, valida o tipo e os
-- limites, guarda em apex_phone_admin ('settings') e aplica no Config do servidor e de todos os clientes
-- (GlobalState 'apex_phone:settings'). Os textos sao a fonte em portugues: a NUI traduz.
--   type: bool | int | num | text | select      group: separador do painel
--   restart = true: so vale para quem entrar depois (o valor e lido no arranque)
-- ------------------------------------------------------------
AdminSchema = {
    groups = {
        { id = 'general', label = 'Geral',          icon = 'gear' },
        { id = 'calls',   label = 'Chamadas',       icon = 'phone' },
        { id = 'number',  label = 'Número e SIM',   icon = 'sim' },
        { id = 'sim',     label = 'SIM e linhas',   icon = 'sim' },   -- eSIM (2026-10-04, server/sim.lua)
        { id = 'psim',    label = 'SIM físico',     icon = 'sim' },   -- PSIM: cartoes SIM no inventario (2026-10-05, server/psim.lua)
        { id = 'social',  label = 'Redes e extras', icon = 'users' },
        { id = 'radio',   label = 'Rádio',          icon = 'mic' },   -- RADIO: app de radio (2026-10-05, server/radio.lua)
        { id = 'cshare',  label = 'Partilha de contactos', icon = 'personCircle' },   -- CSHARE: cartoes de contacto por perto (2026-10-05, server/contactshare.lua)
        { id = 'limits',  label = 'Limites',        icon = 'gauge' },
    },
    settings = {
        { path = 'DefaultLanguage', group = 'general', type = 'select', label = 'Idioma das contas novas',
          options = { 'en', 'pt', 'es', 'fr', 'de', 'it', 'nl', 'pl', 'sv', 'da', 'tr', 'ru', 'ja', 'ko', 'zh-Hans', 'zh-Hant' } },
        { path = 'DefaultTheme', group = 'general', type = 'select', label = 'Tema das contas novas', options = { 'light', 'dark', 'auto' } },
        { path = 'Scale', group = 'general', type = 'num', label = 'Tamanho do telemóvel no ecrã', min = 0.4, max = 1.2, step = 0.01 },
        { path = 'AllowWalking', group = 'general', type = 'bool', label = 'Andar com o telemóvel aberto' },
        { path = 'CameraWalk', group = 'general', type = 'bool', label = 'Andar com a Câmara aberta' },
        { path = 'ShowCursor', group = 'general', type = 'bool', label = 'Mostrar o ponteiro do rato' },
        { path = 'BlockWhenDead', group = 'general', type = 'bool', label = 'Bloquear o telemóvel quando morto' },
        { path = 'RequireItem', group = 'general', type = 'bool', label = 'Precisa do item do telemóvel no inventário' },
        { path = 'PeekSeconds', group = 'general', type = 'int', label = 'Segundos da pré-visualização de avisos', min = 1, max = 15 },
        { path = 'AutoMails', group = 'general', type = 'bool', label = 'Emails automáticos do servidor' },

        { path = 'AutoOpenOnCall', group = 'calls', type = 'bool', label = 'Abrir o telemóvel ao receber uma chamada' },
        { path = 'CallTimeout', group = 'calls', type = 'int', label = 'Segundos a tocar antes de não atendida', min = 5, max = 120 },
        { path = 'UseVoice', group = 'calls', type = 'bool', label = 'Voz nas chamadas' },
        { path = 'ServiceCooldown', group = 'calls', type = 'int', label = 'Segundos entre pedidos a serviços', min = 0, max = 3600 },

        { path = 'NumberPrefix', group = 'number', type = 'text', label = 'Indicativo mostrado antes do número', max = 8 },
        { path = 'AllowSimSwap', group = 'number', type = 'bool', label = 'Permitir trocar de SIM' },
        { path = 'SyncNumberToCharInfo', group = 'number', type = 'bool', label = 'Escrever o número no framework' },

        -- eSIM: Config.Sim (server/sim.lua lê-o a cada uso; mudar aqui vale logo e os telemóveis ligados recebem 'sim:changed')
        { path = 'Sim.required', group = 'sim', type = 'bool', label = 'Exigir um eSIM para ter número' },
        { path = 'Sim.maxLines', group = 'sim', type = 'int', label = 'Números por telemóvel', min = 1, max = 3 },
        { path = 'Sim.allowRemove', group = 'sim', type = 'bool', label = 'Permitir remover linhas' },
        { path = 'Sim.scanSeconds', group = 'sim', type = 'num', label = 'Segundos a ler o código QR', min = 0.8, max = 5, step = 0.1 },

        -- PSIM: Config.PhysicalSim (server/psim.lua). Ligar/desligar so vale depois de reiniciar o Unique_Phone (decide-se no
        -- arranque, depois de o painel carregar); as outras duas leem-se a cada uso
        { path = 'PhysicalSim.enabled', group = 'psim', type = 'bool', label = 'SIM físico: o número vive num cartão SIM (reiniciar o Unique_Phone)', restart = true },
        { path = 'PhysicalSim.starterSim', group = 'psim', type = 'select', label = 'SIM das contas novas', options = { 'auto', 'item', 'none' },
          labels = { auto = 'Número já no telemóvel', item = 'Cartão SIM no inventário', none = 'Sem número até arranjar um SIM' } },
        { path = 'PhysicalSim.esimCards', group = 'psim', type = 'select', label = 'Cartões eSIM com o SIM físico', options = { 'slot', 'off' },
          labels = { slot = 'Metem o número na ranhura vazia', off = 'Desativados' } },
        -- 1.3.0: contactos no cartao e recuperacao de um numero perdido (lidos a cada uso)
        { path = 'PhysicalSim.contactsOnSim', group = 'psim', type = 'bool', label = 'Contactos guardados no cartão SIM' },
        { path = 'PhysicalSim.recover.enabled', group = 'psim', type = 'bool', label = 'Recuperar um número perdido (cartão novo com o mesmo número)' },
        { path = 'PhysicalSim.recover.price', group = 'psim', type = 'num', label = 'Preço da recuperação (banco)', min = 0, max = 1000000, step = 10 },
        { path = 'PhysicalSim.recover.blockOld', group = 'psim', type = 'bool', label = 'Cancelar o cartão antigo para sempre' },

        { path = 'Social.instashot', group = 'social', type = 'bool', label = 'Instashot' },
        { path = 'Social.twix', group = 'social', type = 'bool', label = 'Twix' },
        { path = 'Social.reels', group = 'social', type = 'bool', label = 'Reels' },
        { path = 'Social.darkchat', group = 'social', type = 'bool', label = 'Dark Chat' },
        { path = 'Onion.enabled', group = 'social', type = 'bool', label = 'Mercado anónimo (Onion)' },
        { path = 'Onion.crypto', group = 'social', type = 'bool', label = 'Carteira de cripto' },
        { path = 'Marketplace.transferItems', group = 'social', type = 'bool', label = 'Marketplace entrega itens' },
        { path = 'AI.enabled', group = 'social', type = 'bool', label = 'Assistente Vera Chat' },
        { path = 'Browser.enabled', group = 'social', type = 'bool', label = 'Navegador' },

        -- RADIO: Config.Radio (server/radio.lua le-o a cada uso; desligar ou mudar um requisito desliga logo quem deixar de o cumprir)
        { path = 'Radio.enabled', group = 'radio', type = 'bool', label = 'App Rádio' },
        { path = 'Radio.requireEarbuds', group = 'radio', type = 'bool', label = 'Exigir auriculares postos' },
        { path = 'Radio.requireItem', group = 'radio', type = 'text', label = 'Item obrigatório (vazio = nenhum)', max = 40 },
        { path = 'Radio.showMembers', group = 'radio', type = 'select', label = 'Quem está na frequência', options = { 'names', 'numbers', 'count', 'none' },
          labels = { names = 'Nomes', numbers = 'Números de telefone', count = 'Só quantas pessoas', none = 'Escondido' } },   -- RADIO2: rotulos
        { path = 'Radio.disableWhenDead', group = 'radio', type = 'bool', label = 'Desligar o rádio quando morto' },
        { path = 'Radio.allowInVehicle', group = 'radio', type = 'bool', label = 'Rádio dentro de veículos' },
        { path = 'Radio.keepOnWhenPhoneClosed', group = 'radio', type = 'bool', label = 'Rádio ligado com o telemóvel guardado' },
        { path = 'Radio.privateChannels', group = 'radio', type = 'bool', label = 'Canais privados com código' },
        { path = 'Radio.maxMembersPerChannel', group = 'radio', type = 'int', label = 'Pessoas por frequência (0 = sem limite)', min = 0, max = 200 },
        -- RADIO2: modo de falar e animacao (o cliente le-os a cada uso; mudar o modo com o radio ligado aplica-se em 1 s).
        -- labels: nome mostrado de cada opcao (o valor guardado continua a ser a opcao; a NUI traduz o texto)
        { path = 'Radio.talkMode', group = 'radio', type = 'select', label = 'Modo de falar', options = { 'ptt', 'toggle', 'open' },
          labels = { ptt = 'Manter para falar', toggle = 'Carregar para ligar/desligar', open = 'Microfone aberto' } },
        { path = 'Radio.allowPlayerMode', group = 'radio', type = 'bool', label = 'Cada jogador escolhe o modo de falar' },
        { path = 'Radio.animation.enabled', group = 'radio', type = 'bool', label = 'Animação ao falar' },
        { path = 'Radio.animation.whenPhoneOpen', group = 'radio', type = 'bool', label = 'Animação com o telemóvel na mão' },
        { path = 'Radio.animation.inVehicle', group = 'radio', type = 'bool', label = 'Animação dentro de veículos' },

        -- CSHARE: Config.ContactShare (server/contactshare.lua e client/contactshare.lua leem-no a cada uso: vale logo; as
        -- opcoes do ox_target/qb-target refazem-se em 5 s)
        { path = 'ContactShare.enabled', group = 'cshare', type = 'bool', label = 'Partilha de contactos' },
        { path = 'ContactShare.target', group = 'cshare', type = 'bool', label = 'Opções "Partilhar contacto" no ox_target / qb-target' },
        { path = 'ContactShare.distance', group = 'cshare', type = 'num', label = 'Metros para aparecer na partilha do telemóvel', min = 1, max = 15, step = 0.5 },

        { path = 'MaxPhotos', group = 'limits', type = 'int', label = 'Fotografias por jogador', min = 10, max = 500 },
        { path = 'DarkChatTTL', group = 'limits', type = 'int', label = 'Minutos até apagar o Dark Chat (0 = nunca)', min = 0, max = 10080 },
        { path = 'Notifications.keepDays', group = 'limits', type = 'int', label = 'Dias que as notificações ficam guardadas', min = 1, max = 90 },
        { path = 'Notifications.maxPerPlayer', group = 'limits', type = 'int', label = 'Notificações guardadas por jogador', min = 20, max = 1000 },
    },
}

-- caminho 'A.b' -> valor atual em Config (nil se nao existir)
function AdminSchemaGet(path)
    local t = Config
    for part in tostring(path):gmatch('[^%.]+') do
        if type(t) ~= 'table' then return nil end
        t = t[part]
    end
    return t
end

-- escreve em Config pelo caminho (cria as tabelas intermedias que faltem)
function AdminSchemaSet(path, value)
    local parts = {}
    for part in tostring(path):gmatch('[^%.]+') do parts[#parts + 1] = part end
    local t = Config
    for i = 1, #parts - 1 do
        if type(t[parts[i]]) ~= 'table' then t[parts[i]] = {} end
        t = t[parts[i]]
    end
    t[parts[#parts]] = value
end

-- linha do esquema por caminho
function AdminSchemaFind(path)
    for _, s in ipairs(AdminSchema.settings) do if s.path == path then return s end end
    return nil
end
