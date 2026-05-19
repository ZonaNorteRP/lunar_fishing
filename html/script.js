const FishingApp = {
    currentTab: 'profile',
    
    init() {
        window.addEventListener('message', (event) => {
            const data = event.data;
            
            if (data.action === 'open') {
                this.open(data);
            } else if (data.action === 'close') {
                this.close();
            } else if (data.action === 'updateMarket') {
                this.renderMarket(data.prices);
            }
        });

        this.setupEventListeners();
    },

    open(data) {
        const isOpen = document.getElementById('app').style.display === 'flex';
        document.getElementById('app').style.display = 'flex';
        this.updatePlayerData(data.player);
        this.renderStore(data.config);
        this.renderMarket(data.marketPrices);
        this.renderBoats(data.config.renting.boats);
        if (!isOpen) {
            this.switchTab('profile');
        }
    },

    close() {
        document.getElementById('app').style.display = 'none';
        fetch(`https://${GetParentResourceName()}/close`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            },
            body: JSON.stringify({})
        });
    },

    setupEventListeners() {
        // Tab switching
        document.querySelectorAll('.nav-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                this.switchTab(btn.dataset.tab);
            });
        });

        // Close button
        document.getElementById('closeTablet').addEventListener('click', () => {
            this.close();
        });

        // Close on ESC
        window.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') this.close();
        });
    },

    switchTab(tabId) {
        this.currentTab = tabId;
        
        // Update Buttons
        document.querySelectorAll('.nav-btn').forEach(btn => {
            btn.classList.toggle('active', btn.dataset.tab === tabId);
        });

        // Update Content
        document.querySelectorAll('.tab-content').forEach(content => {
            content.classList.toggle('hidden', content.id !== `tab-${tabId}`);
        });

        // Update Title
        const meta = {
            profile: { title: 'Perfil do Pescador', desc: 'Veja seu progresso e conquistas.' },
            store: { title: 'Loja de Pesca', desc: 'Equipamentos e suprimentos de qualidade.' },
            market: { title: 'Mercado de Peixes', desc: 'Preços dinâmicos baseados na oferta local.' },
            boats: { title: 'Aluguel de Barcos', desc: 'Explore águas profundas com nossos barcos.' }
        };

        if (meta[tabId]) {
            document.getElementById('currentTabTitle').textContent = meta[tabId].title;
            document.getElementById('currentTabDesc').textContent = meta[tabId].desc;
        }
    },

    updatePlayerData(data) {
        this.playerLevel = data.level || 0;
        document.getElementById('playerBalance').textContent = `R$ ${data.balance.toLocaleString()}`;
        document.getElementById('currentLevel').textContent = data.level;
        document.getElementById('levelXpText').textContent = `${data.xp} / ${data.nextLevelXp} XP`;
        
        const progress = (data.xp / data.nextLevelXp) * 100;
        document.getElementById('levelProgressBar').style.width = `${progress}%`;
        
        document.getElementById('totalCaught').textContent = data.totalCaught || 0;
        document.getElementById('biggestCatch').textContent = data.biggestCatch || '-';
    },

    renderStore(config) {
        const rodsContainer = document.getElementById('rodsContainer');
        const baitsContainer = document.getElementById('baitsContainer');
        const playerLevel = this.playerLevel || 0;
        
        rodsContainer.innerHTML = '';
        config.fishingRods.forEach((rod, index) => {
            rodsContainer.appendChild(this.createItemCard(rod, 'rod', index, playerLevel));
        });

        baitsContainer.innerHTML = '';
        config.baits.forEach((bait, index) => {
            baitsContainer.appendChild(this.createItemCard(bait, 'bait', index, playerLevel));
        });
    },

    renderMarket(prices) {
        const container = document.getElementById('marketContainer');
        container.innerHTML = '';
        
        if (!prices) return;

        for (const [name, price] of Object.entries(prices)) {
            const card = document.createElement('div');
            card.className = 'item-card market-item';
            
            // Note: In a real app, you'd match the name with a label and image
            card.innerHTML = `
                <img src="nui://ox_inventory/web/images/${name}.png" class="item-img" onerror="this.src='https://i.postimg.cc/mDSqWj4P/164px-Speeder.webp'">
                <div class="item-name">${name.replace('_', ' ').toUpperCase()}</div>
                <div class="item-price">R$ ${price}</div>
                <button class="btn-buy" onclick="FishingApp.sellItem('${name}')">VENDER TUDO</button>
            `;
            container.appendChild(card);
        }
    },

    renderBoats(boats) {
        const container = document.getElementById('boatsContainer');
        container.innerHTML = '';
        
        boats.forEach((boat, index) => {
            const card = document.createElement('div');
            card.className = 'item-card';
            const boatName = boat.label || boat.name || (typeof boat.model === 'string' ? boat.model : 'Barco ' + (index + 1));
            card.innerHTML = `
                <img src="${boat.image}" class="item-img">
                <div class="item-name">${boatName.toUpperCase()}</div>
                <div class="item-price">R$ ${boat.price}</div>
                <button class="btn-buy" onclick="FishingApp.rentBoat(${index})">ALUGAR</button>
            `;
            container.appendChild(card);
        });
    },

    createItemCard(item, type, index, playerLevel) {
        const card = document.createElement('div');
        const isLocked = playerLevel < item.minLevel;
        card.className = `item-card ${isLocked ? 'locked' : ''}`;
        
        card.innerHTML = `
            <img src="nui://ox_inventory/web/images/${item.name}.png" class="item-img" onerror="this.src='https://i.postimg.cc/mDSqWj4P/164px-Speeder.webp'">
            <div class="item-name">${item.name.replace('_', ' ').toUpperCase()}</div>
            <div class="item-price">R$ ${item.price}</div>
            <button class="btn-buy" ${isLocked ? 'disabled' : ''} onclick="FishingApp.buyItem('${type}', ${index})">COMPRAR</button>
            <div class="lock-overlay">
                <i class="fas fa-lock"></i>
                <span>Nível ${item.minLevel} Necessário</span>
            </div>
        `;
        return card;
    },

    buyItem(type, index) {
        fetch(`https://${GetParentResourceName()}/buyItem`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            },
            body: JSON.stringify({ type, index })
        });
    },

    sellItem(fishName) {
        fetch(`https://${GetParentResourceName()}/sellItem`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            },
            body: JSON.stringify({ fishName })
        });
    },

    rentBoat(index) {
        fetch(`https://${GetParentResourceName()}/rentBoat`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            },
            body: JSON.stringify({ index })
        });
        this.close();
    }
};

FishingApp.init();
