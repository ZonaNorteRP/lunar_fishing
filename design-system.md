# IDENTIDADE VISUAL — ZN Racing System

## Contexto do Projeto

- **Nome:** ZN Racing System
- **O que faz:** Script de corridas de rua para FiveM. Cobre todo o ciclo: lobby de espera, HUD em tempo real durante a corrida, marcadores de checkpoint no mundo 3D, tablet de gestão (corridas, lobbies, ranking, perfil, admin).
- **Para quem:** Jogadores de servidores FiveM roleplay/racing. Perfil jovem (18–30), familiarizado com jogos competitivos, valoriza estética premium e leitura rápida de informação em jogo.
- **Sensação desejada:** Tecnológico, preciso, veloz. Como estar na cabine de um carro de corrida com dados em tempo real — cada informação no lugar exato, sem excesso, sem ruído.
- **O que NÃO quer parecer:** Script genérico de FiveM com gradientes em tudo, dashboard corporativo, template azul padrão com border-radius exagerado.
- **Modo:** Dark only.
- **Referência de energia:** "A precisão do Linear + a energia tech do Supabase — mas com azul elétrico como cor de marca."

---

## AVISO CRITICO: PRESERVAR FUNCIONALIDADE

**O sistema de mensagens NUI está 100% funcional.** Toda comunicação entre Lua e NUI usa `window.postMessage` com o evento `message`. O redesign deve:

- **Manter todos os `id` de elementos** que o JavaScript usa para manipular o DOM (ex: `#raceHUD`, `#rankingHUD`, `#rankingList`, `#hudLap`, `#hudPosition`, `#hudCheckpoint`, `#hudProgressBar`, `#countdown`, `#tablet`, `#registerScreen`, etc.)
- **Manter todas as classes e lógicas de visibilidade** controladas por JS (`.active`, `display: none/flex/block`)
- **Nunca remover ou renomear** funções JS existentes (`openRaceHUD`, `closeRaceHUD`, `updateRaceHUD`, `openTablet`, `openLobby`, etc.)
- **Nunca alterar** as chamadas `fetch('https://jack_race/...')` — são callbacks para o Lua
- O redesign é puramente visual: substituir CSS e HTML estrutural mantendo todos os ganchos funcionais intactos
- Em caso de dúvida entre preservar funcionalidade e aplicar identidade visual: **funcionalidade vence sempre**

---

## Stack Técnica

- HTML + CSS vanilla para toda estilização (os arquivos `style.css`, `race.html` e `tablet.html` já existem — o redesign edita esses arquivos)
- JavaScript vanilla já implementado e funcional — **não tocar na lógica, apenas no HTML/CSS**
- Tokens visuais implementados como CSS Custom Properties (`:root { --token: valor; }`) e usados via `var(--token)` em todo o CSS
- **Nunca** usar valores hardcoded no CSS — sempre via `var(--token)`
- Font Awesome 6 já carregado — manter para ícones
- Google Fonts pode ser adicionado para tipografia (ver seção de tipografia)
- SVG inline para conceitos visuais — implementado diretamente no HTML

### Fonts a adicionar
| Font | Uso | Import |
|---|---|---|
| `JetBrains Mono` | Dados numéricos em tempo real (tempos, posições, distâncias) | Google Fonts |
| `Inter` | Labels, nomes, textos de interface | Google Fonts (ou usar system-font stack já existente) |

---

## A Alma do App

ZN Racing não é uma tela de jogo — é um cockpit. Cada informação que aparece ali tem um papel técnico: onde você está, quão longe está do próximo checkpoint, quanto tempo está perdendo para o líder. A identidade visual serve a esse propósito: dados legíveis na fração de segundo, hierarquia cristalina, azul elétrico como a única cor que importa.

---

## Referências Analisadas e Princípios Extraídos

- **HUD de corrida (imagem 1 — ranking lateral):** Painel semi-transparente escuro à esquerda, posição numérica grande, lista de players com position badge colorido (ouro/prata/bronze), nome e gap de tempo. Informação hierarquizada: posição > nome > gap. Fundo quase preto com opacidade, não interfere no gameplay.
  **Princípio:** O HUD não compete com o jogo — ele se sobrepõe com delicadeza e entrega só o essencial. Badge de posição com cor funcional (ouro=1º, prata=2º, bronze=3º), restante em neutro.

- **HUD de corrida (imagem 2 — status à direita):** Nome da corrida em caps bold, label "CHECKPOINTS" pequena uppercase + valor grande, dois timers com ícone. Tipografia monospace para dados de tempo. Contraste alto entre label (muted) e valor (branco bold).
  **Princípio:** Labels em uppercase muted + valores em branco bold é a linguagem dos dados em tempo real. Monospace para números cria ritmo visual e facilita leitura rápida.

- **Marcadores de checkpoint no mundo (imagens 3 e 4):** Linha vertical fina e alta (beam), distância em tipografia enorme bold branca, "CHECKPOINT" em letra menor com muito tracking, seta apontando para baixo. A cor de destaque era amarela — trocar para azul (#2563EB) como identidade do script.
  **Princípio:** O marcador deve comunicar UMA informação dominante (a distância) com máxima legibilidade contra qualquer fundo. Texto grande + cor única de accent + linha vertical como âncora espacial.

- **Tablet — Interface de corridas em andamento (imagem 5):** Navigation bar no topo centralizada com ícones de categorias, segmented control para filtros de seção, cards de corrida com top 3 interno, badge "Ranqueada". Fundo muito escuro (#0D0D14 aproximadamente), elementos em dark navy (#12121F). Cor accent roxo — trocar para azul.
  **Princípio:** Top bar com ícones > sidebar. Eliminar sidebar libera 100% da largura para o conteúdo. Segmented control para filtros = navegação sem re-render de tela inteira.

- **Tablet — Leaderboard/Classificação (imagem 6):** Tabela clean com rank, avatar redondo com thumbnail do personagem, nome, crew, win rate em badge pill, races e rating em badge pill. Campo de busca no topo. Hover row highlight sutil. Sem bordas entre colunas — espaçamento resolve a separação.
  **Princípio:** Tabela de dados sem ruído visual. Avatar + nome juntos como unidade. Badges pill para métricas numéricas. Busca inline no topo da tabela.

- **Linear (referência de precisão):** Fontes pequenas, muito espaçamento, transições de 150ms, hierarquia de cor em 3 níveis (primary/secondary/muted), sem decoração. Tudo serve a uma função.
  **Princípio:** Cada pixel tem função. Remover é melhorar.

- **Supabase (referência de energia tech):** Fundo muito escuro, UMA cor vibrante (verde deles, nosso azul), conceitos visuais SVG dentro de cards que contam histórias, monospace para código/dados.
  **Princípio:** Dark + UMA cor forte = identidade reconhecível. Conceito visual > decoração.

---

## Decisões de Identidade

### ESTRUTURA

#### HUD de Corrida — Layout Bipartido
**O que:** Dois painéis independentes, posicionados em lados opostos da tela. Esquerda: ranking de players. Direita: status técnico da corrida (volta, checkpoint, progresso, tempo).
**Por que:** Separa a informação social (quem está onde) da informação técnica (como está minha corrida). O jogador move o olhar para o lado correto dependendo do que precisa saber.
**Como:** Painel esquerdo fixo em `top: 20px; left: 20px`. Painel direito fixo em `top: 20px; right: 20px`. Ambos com `pointer-events: none` para não interferir no controle. Largura máxima de 280px cada.
**Nunca:** Centralizar ou agrupar os dois painéis. Nunca colocar os dois no mesmo lado.

#### Tablet — Navegação por Top Bar com Ícones
**O que:** Barra horizontal estreita no topo da interface, com ícones de categoria centralizados. Abaixo, segmented control pill para sub-seções quando necessário.
**Por que:** Sidebar ocupa espaço horizontal valioso dentro de um tablet de 1280px. Top bar com ícones permite que o conteúdo use 100% da largura disponível.
**Como:** Barra com altura de ~52px, fundo levemente mais escuro que o tablet. Ícones de ~20px com tooltip on-hover. Ícone ativo recebe `var(--accent-primary)`, inativos recebem `var(--text-muted)`. Abaixo da bar, um container de ~44px para os pills de sub-seção quando existirem.
**Nunca:** Usar sidebar lateral. Nunca mostrar texto + ícone nos tabs superiores (só ícone — labels ficam no tooltip ou no título da seção).

#### Tablet — Leaderboard como Tabela, Não Cards
**O que:** Rankings e listagens de players usam layout de tabela com linhas, não grid de cards.
**Por que:** Tabela permite comparação direta entre linhas. Cards fragmentam a informação e forçam o olho a reconstruir a comparação. Para dados de ranking, tabela é superior.
**Como:** Colunas fixas: Rank | Player (avatar + nome) | Win Rate | Corridas | Rating. Linhas com padding vertical de 12px. Hover com fundo `var(--surface-hover)`. Sem bordas entre colunas — gap resolve. Badges pill para valores numéricos de destaque.
**Nunca:** Colocar ranking em grid de cards. Nunca usar bordas horizontais entre todas as linhas (apenas uma borda sutil abaixo do header).

#### Marcador de Checkpoint — Elemento World-Space
**O que:** Overlay posicionado no espaço do jogo, não na UI. Linha vertical + distância em tipografia dominante + label + seta.
**Por que:** O jogador precisa saber a distância do próximo ponto sem tirar os olhos da estrada. O marcador deve ser lido perifericamente.
**Como:** Estrutura vertical: número de distância (grande, monospace, branco) + label "CHECKPOINT" (pequena, uppercase, muito tracking, `var(--accent-primary)`) + linha vertical fina (1–2px, `var(--accent-primary)`, altura total da tela ou até 80vh) + seta para baixo. Background transparente.
**Nunca:** Usar caixa com fundo no marcador de checkpoint. Nunca usar a cor amarela original — substituir por `var(--accent-primary)`.

---

### LINGUAGEM

#### Tipografia — Dois Papéis Distintos
**O que:** Dois tipos de texto com funções opostas: dados (números em tempo real) usam `JetBrains Mono`; interface (labels, nomes, títulos) usam `Inter`.
**Por que:** Monospace para dados cria alinhamento visual em colunas e comunica precisão técnica. Inter para texto mantém legibilidade confortável. A distinção entre os dois tipos sinaliza ao olho: "esse número é dado, esse texto é contexto".
**Como:**
- `JetBrains Mono` para: tempos (`02:23.484`), distâncias (`53M`, `319M`), contadores (`41/91`), posições numéricas, rating, win rate
- `Inter` para: nomes de jogadores, títulos de corrida, labels, descrições, botões
**Nunca:** Usar fonte serifada em qualquer contexto. Nunca misturar monospace com valores não-numéricos.

#### Cor — Uma Única Cor de Marca
**O que:** Azul elétrico `#2563EB` como única cor vibrante da interface. Todo o resto é escala de neutros escuros.
**Por que:** Uma cor forte é uma identidade. Múltiplas cores são ruído. O azul aparece em: ícone ativo da nav, badges de destaque, barras de progresso, linha do marcador de checkpoint, label "CHECKPOINT", botão primário, posição do jogador no ranking (destaque), acento do countdown.
**Como:** Ver Tokens de Design abaixo. A cor aparece como sólido nos elementos de ação, como `var(--accent-subtle)` (azul com 10–15% opacidade) em fundos de badge e hover.
**Nunca:** Usar roxo. Nunca usar mais de uma cor vibrante. Nunca aplicar gradientes coloridos como identidade — gradiente pontual em botão é aceitável, mas não é a identidade.

#### Geometria — Cantos Funcionais
**O que:** `border-radius` de 8px para cards e painéis. 6px para badges e itens de lista. 10px para modais. 4px para elementos pequenos (badges inline). Botões: 8px.
**Por que:** Cantos arredondados de 8px comunicam modernidade sem cair no excesso pill/rounded-full que parece app mobile. É a geometria do Linear — preciso, funcional.
**Como:** Ver Tokens de Design.
**Nunca:** Usar `border-radius: 50%` para qualquer elemento que não seja avatar. Nunca usar `rounded-full` em cards ou botões principais.

#### Profundidade — Flat com Bordas Sutis
**O que:** Sem sombras grandes ou coloridas. Profundidade criada por diferença de tom de fundo (page → card → elevated) e borda de 1px `rgba(255,255,255,0.06)`.
**Por que:** Sombras coloridas e glow em tudo é ruído. A hierarquia de camadas (fundo da página mais escuro que o card, card mais escuro que o elemento elevado) já comunica profundidade.
**Como:** Três tons de fundo: `var(--surface-page)` (mais escuro), `var(--surface-card)` (card), `var(--surface-elevated)` (dropdown, tooltip, modal). Cada nível 5–8% mais claro que o anterior.
**Nunca:** Usar `box-shadow` colorida como regra geral. Nunca usar glassmorphism em toda a interface.

#### Painéis do HUD — Semi-Transparência Calibrada
**O que:** Os painéis do HUD em corrida usam fundo `rgba(5, 7, 13, 0.88)` — quase opaco, mas com 12% de transparência para que o jogo apareça sutilmente atrás.
**Por que:** Transparência total torna ilegível. Opacidade total bloqueia a percepção do ambiente. 88% de opacidade é o ponto certo: legível, mas contextualizado.
**Como:** `background: rgba(5, 7, 13, 0.88)` nos painéis. `backdrop-filter: blur(4px)` sutil para suavizar o fundo do jogo.
**Nunca:** Usar transparência abaixo de 80% em painéis com dados críticos — legibilidade primeiro.

#### Hierarquia de Texto no HUD — Label + Valor
**O que:** Todo dado em tempo real é apresentado como par: label pequena uppercase muted + valor grande bold branco.
**Por que:** O olho primeiro captura o valor (grande), depois confirma o contexto com a label (pequena). Isso permite leitura em fração de segundo sem precisar ler o texto completo.
**Como:**
- Label: `font-size: 10px; text-transform: uppercase; letter-spacing: 0.08em; color: var(--text-muted);`
- Valor: `font-size: 22–28px; font-weight: 700; color: #ffffff; font-family: JetBrains Mono;`
**Nunca:** Colocar label e valor no mesmo tamanho. Nunca usar valor em cor muted.

#### Badges de Posição no Ranking
**O que:** Position badge como quadrado de 28x28px com `border-radius: 6px`. 1º lugar: gradiente dourado. 2º: gradiente prata. 3º: gradiente âmbar/bronze. Demais: `var(--surface-elevated)` neutro escuro.
**Por que:** Cor funcional — só os três primeiros têm destaque visual. O resto não compete.
**Como:** Ver Tokens de Design — `--rank-gold`, `--rank-silver`, `--rank-bronze`.
**Nunca:** Usar cor de destaque para posições abaixo do top 3. Nunca usar apenas texto para o position badge — sempre com fundo colorido.

---

### RIQUEZA VISUAL

#### Textura Ambiente
**O que:** Pattern de linhas de velocidade horizontais levíssimas no fundo do tablet e de telas escuras. São linhas finas de 1px, horizontais, espaçadas de ~40px, com opacidade de 3–4%.
**Temática:** Linhas de velocidade são o símbolo visual de movimento rápido em corridas. Em baixíssima opacidade, criam a sensação de "estar em movimento" sem distrair.
**Tratamento:** SVG de background com `<pattern>`, aplicado via `background-image` no body ou container principal do tablet. Cor: branco em 4% opacidade. Fixo (não move com scroll). Apenas nas superfícies de fundo — nunca dentro de cards.

---

#### Conceito Visual: HUD Ranking Panel (lado esquerdo, in-race)

**Representa:** A corrida como uma competição ao vivo — onde estou em relação aos outros agora, quem estou perdendo, quem estou batendo.

**Metáfora visual:** Uma lista de resultados em tempo real, como um placar esportivo digital. Cada linha é um corredor com identidade visual própria.

**Cena detalhada:**
O painel tem largura de 280px. No topo, uma linha de cabeçalho estreita mostra: sua posição atual em destaque azul (`3°`) à esquerda, e informações da corrida à direita (`VOLTA 2/3` em monospace muted). Abaixo, a lista de players em ordem de posição.

Cada item de player ocupa uma linha com altura de ~52px, padding de 10px 12px, fundo `var(--surface-card)` com `backdrop-filter: blur(4px)`. A linha do jogador atual tem uma borda esquerda de 3px em `var(--accent-primary)` e fundo levemente mais claro (`var(--surface-elevated)`).

Estrutura de cada linha (da esquerda para direita):
1. Position badge: 28x28px, `border-radius: 6px`, com cor funcional (ouro/prata/bronze/neutro). Texto: número + "º" em `JetBrains Mono` bold.
2. Avatar placeholder: círculo de 32px com fundo `var(--surface-elevated)` e ícone de usuário. Quando thumbnail disponível, imagem circular.
3. Nome: `font-size: 14px; font-weight: 600;` branco. Máx 140px com truncamento `...`
4. Gap de tempo: alinhado à direita, `font-size: 12px; color: var(--text-muted); font-family: JetBrains Mono`. Formato: `+0.849s`. Para o líder: `-` ou `LÍDER`.

Animação de entrada: `translateX(-20px) opacity(0)` para `translateX(0) opacity(1)` em 300ms quando a lista atualiza. Mudança de posição entre updates: transição de `background-color` de 200ms para indicar subida (verde sutil) ou queda (vermelho sutil) — fade out em 1s.

**Viabilidade:** CÓDIGO PURO — SVG para ícone de avatar, CSS para layout, JS já implementado.

---

#### Conceito Visual: HUD Status Panel (lado direito, in-race)

**Representa:** O estado técnico da minha corrida — estou progredindo? Estou rápido? Onde estou nesta volta?

**Metáfora visual:** Painel de instrumentos de cockpit. Dados organizados em blocos modulares, como displays de telemetria.

**Cena detalhada:**
Painel de largura 240px, posicionado `top: 20px; right: 20px`. Série de "instrumentos" empilhados verticalmente com gap de 8px.

Cada instrumento é um card de `var(--surface-card)` com padding 14px e `border-radius: var(--radius-card)`. Estrutura interna:
- Label superior: `10px uppercase tracking-wide var(--text-muted)`, com ícone Font Awesome de 11px antes do texto
- Valor: `22–28px JetBrains Mono font-weight: 700 white`

Hierarquia de instrumentos (de cima para baixo):
1. NOME DA CORRIDA — apenas no topo, caps, bold, 16px, sem ícone, identifica o contexto
2. VOLTA ATUAL — ícone `fa-flag-checkered`, valor `2 / 3`
3. POSIÇÃO — ícone `fa-trophy`, valor `3 / 8`
4. CHECKPOINT — ícone `fa-location-dot`, valor `41 / 91`
5. PROGRESSO — ícone `fa-chart-line`, valor porcentagem + barra horizontal abaixo do valor. A barra tem 6px de altura, fundo `rgba(255,255,255,0.1)`, preenchimento `var(--accent-primary)` com `border-radius: 10px`. `transition: width 0.3s ease`.
6. TEMPO — ícone `fa-clock`, valor em monospace `02:23.484` — este deve ter fonte levemente maior (26px) pois é o dado mais consultado

**Viabilidade:** CÓDIGO PURO.

---

#### Conceito Visual: Marcador de Checkpoint (world-space overlay)

**Representa:** "O próximo ponto está aqui, a esta distância." Orientação espacial durante a corrida.

**Metáfora visual:** Uma baliza vertical de luz — como um feixe laser fino que sobe do chão até o infinito, marcando um ponto no espaço. O número grande é o único texto que importa.

**Cena detalhada:**
Estrutura vertical de cima para baixo, centralizada na tela horizontalmente sobre o ponto de interesse:

1. **Distância** (elemento dominante): número grande em `JetBrains Mono`, `font-weight: 900`, `font-size: clamp(48px, 8vw, 80px)`, cor branca pura. Seguido imediatamente por "M" em tamanho ~60% do número. Ex: `53M`.

2. **Label "CHECKPOINT"**: abaixo do número, `font-size: 12px; letter-spacing: 0.25em; text-transform: uppercase; color: var(--accent-primary); font-weight: 600`. Linha horizontal fina de 1px em `var(--accent-primary)` com 40px de largura, centralizada, acima do texto da label, com `margin-bottom: 4px`.

3. **Seta indicadora**: ícone chevron-down ou triângulo SVG apontando para baixo, `color: var(--accent-primary)`, `font-size: 16px`, com animação de `translateY(-4px → 0 → -4px)` em loop de 1.2s (bouncing sutil).

4. **Linha vertical** (âncora espacial): linha SVG de 2px de largura, de altura total (100vh ou o que couber), cor `var(--accent-primary)` em 60% opacidade, centrada no elemento. Efeito de fade: opaca no ponto de checkpoint, desvanecendo para cima e para baixo.

Todo o conjunto sobre `background: transparent`. Sem caixa, sem fundo.

**Viabilidade:** CÓDIGO PURO — HTML/CSS com SVG para a linha.

---

#### Conceito Visual: Tablet — Card de Corrida

**Representa:** Uma corrida disponível para entrar — é uma oportunidade, um desafio que aguarda. Não é apenas uma listagem de dados.

**Metáfora visual:** Uma pista de corrida estilizada como wireframe em perspectiva isométrica leve — linhas que formam uma rota que vai de um ponto a outro, representando o percurso que o jogador vai completar.

**Cena detalhada:**
Cada card (dentro do grid de corridas) tem um bloco visual no canto superior direito, dimensões ~80x80px, com baixíssima opacidade (6–8%).

O bloco é um SVG inline com:
- Uma rota tracejada em curva suave (`stroke-dasharray`), de dois pontos circulares (origem de 6px, destino de 10px)
- A rota tem `stroke: var(--accent-primary); opacity: 0.08`
- Os pontos têm `fill: var(--accent-primary); opacity: 0.12`
- Pequeno triângulo (veículo) posicionado sobre a rota, `fill: var(--accent-primary); opacity: 0.15`

Este SVG fica em `position: absolute; right: 0; top: 0; overflow: hidden; border-radius: 0 var(--radius-card) 0 0` — só aparece no canto sem sobrepor texto.

O restante do card:
- Header: nome da corrida em 18px bold + badge de prêmio com fundo `var(--rank-gold)` (dourado) em 14px bold
- Info grid de 3 colunas: Checkpoints | Voltas | Corridas (usando o padrão label muted + valor bold)
- Footer: descrição curta em 12px muted

**Viabilidade:** CÓDIGO PURO — SVG inline.

---

#### Conceito Visual: Tablet — Lobby Atual (aba in-lobby)

**Representa:** A sala de espera antes da largada — todos os pilotos reunidos, aguardando o host dar o sinal. Tensão de pré-corrida.

**Metáfora visual:** Uma grade de pilotos como um grid de largada — cada posição na lista representa uma vaga na corrida, e o host é o pole position.

**Cena detalhada:**
O card de informações da corrida no topo usa o padrão label + valor. Mas o fundo desse card tem um detalhe adicional: três linhas horizontais espaçadas de 8px (como linhas de largada de um grid de F1), em `var(--accent-primary)` com opacidade de 4%, ocupando toda a largura do card.

Lista de players:
- Cada item: fundo `var(--surface-card)`, padding 12px 16px, `border-radius: 8px`
- Item do host: borda esquerda de 3px em `#fbbf24` (âmbar, cor funcional para "líder/host"), fundo com tint âmbar em 5% opacidade
- Avatar circular 40px com ícone de usuário
- Nome em 15px bold branco
- Badge "HOST" em pill para o host: fundo `rgba(251, 191, 36, 0.15)`, texto `#fbbf24`, uppercase tiny
- Indicador de status "Pronto" à direita: ponto verde pulsante de 8px + texto 13px muted verde

O ponto verde pulsante: círculo SVG com animação `scale(1 → 1.4 → 1)` em 2s loop, opacidade `1 → 0.4 → 1` simultânea. Comunica que o jogador está conectado em tempo real.

**Viabilidade:** CÓDIGO PURO.

---

#### Conceito Visual: Tablet — Leaderboard / Hall da Fama

**Representa:** A hierarquia competitiva do servidor — quem são os melhores, onde me situo entre eles.

**Metáfora visual:** Placar esportivo de elite. Layout de tabela limpa com hierarquia visual clara — os três primeiros recebem tratamento especial, o restante é linha.

**Cena detalhada:**
Tabela com colunas: Rank | Piloto | Recordes | Vitórias | Participações | Win Rate

Os três primeiros itens (pódio) recebem tratamento diferenciado:
- `#1`: fundo da linha com tint âmbar `rgba(251, 191, 36, 0.05)`, rank badge dourado 48x48px com `border-radius: 12px`
- `#2`: tint prata `rgba(156, 163, 175, 0.05)`, rank badge prata
- `#3`: tint bronze `rgba(249, 115, 22, 0.05)`, rank badge bronze

Da posição 4 em diante: linha neutra sem tint. Rank em número puro, fundo neutro escuro.

O "valor destaque" de cada linha é o número de corridas participadas (coluna mais à direita) — em `JetBrains Mono` e `var(--accent-primary)`, funcionando como o "score" do jogador.

Campo de busca no topo da seção: fundo `var(--surface-card)`, sem borda visível por padrão, borda azul em focus, ícone de lupa à esquerda em `var(--text-muted)`, placeholder "Buscar corredor..." em muted.

**Viabilidade:** CÓDIGO PURO.

---

#### Conceito Visual: Countdown (tela cheia, pré-largada)

**Representa:** O momento de maior tensão do script — a contagem regressiva antes da largada. Deve ser visceral.

**Metáfora visual:** O número domina a tela, como um semáforo de F1 gigante. Pulsa como um batimento cardíaco acelerado.

**Cena detalhada:**
Número centralizado na tela. `font-size: 160px; font-family: JetBrains Mono; font-weight: 900`. Para 3, 2, 1: cor branca, `text-shadow: 0 0 60px rgba(255,255,255,0.4)`.

Animação de entrada em cada número: `scale(1.3) opacity(0)` → `scale(1.0) opacity(1)` em 150ms ease-out. Animação de saída antes do próximo número: `scale(0.8) opacity(0)` em 150ms ease-in.

Ao mostrar "VAI!": cor muda para `var(--accent-primary)`, `text-shadow: 0 0 80px rgba(37, 99, 235, 0.9)`. O mesmo scale-in de entrada, mas seguido de `scale(1.0)` se mantendo por 1.2s antes de sair com `scale(1.1) opacity(0)`.

Fundo durante o countdown: overlay de 40% de opacidade preto (`rgba(0,0,0,0.4)`) sobre o jogo, removido quando "VAI!" desaparece.

**Viabilidade:** CÓDIGO PURO.

---

## Tokens de Design

### Cores — Fundos
| Token | Valor | Uso |
|---|---|---|
| `--surface-page` | `#05070d` | Fundo principal do body/app |
| `--surface-card` | `#0a0e1a` | Cards, painéis do HUD |
| `--surface-elevated` | `#0f1424` | Modais, dropdowns, elemento elevado |
| `--surface-hover` | `#141929` | Hover state de linhas/itens |
| `--surface-hud` | `rgba(5, 7, 13, 0.88)` | Painéis do HUD in-race (semi-transparente) |

### Cores — Texto
| Token | Valor | Uso |
|---|---|---|
| `--text-primary` | `#ffffff` | Títulos, valores principais, nomes |
| `--text-secondary` | `#d1d5db` | Texto de apoio, descrições |
| `--text-muted` | `#6b7280` | Labels, hints, placeholders, metadados |

### Cores — Accent (UMA COR)
| Token | Valor | Uso |
|---|---|---|
| `--accent-primary` | `#2563EB` | A COR da marca — botões, links, ícones ativos, checkpoints, barras de progresso, valores de destaque |
| `--accent-hover` | `#1d4ed8` | Hover state do accent |
| `--accent-light` | `#3b82f6` | Variante mais clara — gradiente interno do botão, texto sobre fundo escuro |
| `--accent-subtle` | `rgba(37, 99, 235, 0.12)` | Fundos translúcidos (badge tint, hover tint, row highlight) |

### Cores — Status (APENAS feedback funcional)
| Token | Valor | Uso |
|---|---|---|
| `--status-success` | `#10b981` | Lobby pronto, corrida iniciada, confirmação |
| `--status-error` | `#ef4444` | Erro, banido, cancelado |
| `--status-warning` | `#f59e0b` | Pendente, aguardando, atenção |

### Cores — Ranking / Pódio (funcionais, não decorativas)
| Token | Valor | Uso |
|---|---|---|
| `--rank-gold` | `linear-gradient(135deg, #fbbf24, #f59e0b)` | Badge 1º lugar |
| `--rank-silver` | `linear-gradient(135deg, #9ca3af, #6b7280)` | Badge 2º lugar |
| `--rank-bronze` | `linear-gradient(135deg, #f97316, #ea580c)` | Badge 3º lugar |
| `--rank-default` | `#1e3a8a` | Badge 4º em diante |

### Bordas
| Token | Valor | Uso |
|---|---|---|
| `--border-default` | `rgba(255, 255, 255, 0.07)` | Bordas de cards, painéis |
| `--border-subtle` | `rgba(255, 255, 255, 0.04)` | Separadores, divisórias |
| `--border-accent` | `rgba(37, 99, 235, 0.4)` | Borda de elemento em foco ou selecionado |

### Geometria
| Token | Valor | Uso |
|---|---|---|
| `--radius-card` | `12px` | Cards, painéis do HUD |
| `--radius-button` | `8px` | Botões |
| `--radius-input` | `8px` | Inputs |
| `--radius-badge` | `6px` | Badges quadrados (position badge) |
| `--radius-pill` | `999px` | Badges pill (status, win rate) |
| `--radius-modal` | `16px` | Modais |
| `--radius-avatar` | `50%` | Avatares |

### Sombras
| Token | Valor | Uso |
|---|---|---|
| `--shadow-card` | `0 2px 8px rgba(0,0,0,0.4)` | Cards em repouso |
| `--shadow-hover` | `0 8px 24px rgba(0,0,0,0.5)` | Cards em hover |
| `--shadow-modal` | `0 24px 64px rgba(0,0,0,0.8)` | Modais |
| `--shadow-hud` | `0 4px 20px rgba(0,0,0,0.6)` | Painéis do HUD |

### Tipografia
| Token | Valor | Uso |
|---|---|---|
| `--font-interface` | `'Inter', -apple-system, sans-serif` | Textos de interface gerais |
| `--font-data` | `'JetBrains Mono', 'Roboto Mono', monospace` | Dados numéricos em tempo real |

### Transições
| Token | Valor | Uso |
|---|---|---|
| `--transition-fast` | `150ms ease` | Hover de botões, ícones |
| `--transition-base` | `250ms ease` | Transições de painel, mudança de tab |
| `--transition-slow` | `350ms ease` | Abertura de modal, slide-in de HUD |

---

## Regra de Ouro

Ao criar ou redesenhar qualquer tela ou componente:

1. Todos os `id` e classes funcionais do JS existente devem ser mantidos intactos — o redesign não quebra nenhuma lógica de evento, mensagem ou DOM manipulation
2. APENAS CSS Custom Properties (`var(--token)`) — nunca valores hardcoded no CSS
3. UMA cor accent para tudo — `var(--accent-primary)`. Nenhuma outra cor vibrante além das funcionais de status e pódio
4. Labels uppercase muted + valores brancos bold monospace = a linguagem dos dados em tempo real
5. Cada componente importante tem um CONCEITO VISUAL descrito neste documento — não decoração genérica
6. Fonts: `var(--font-data)` para números, `var(--font-interface)` para texto
7. O checkpoint marker usa `var(--accent-primary)` em substituição ao amarelo original — é a mudança mais visível da identidade no mundo do jogo
8. ZN Racing é um cockpit, não uma vitrine. Cada elemento serve a uma função.

## Teste Final

Coloque a interface ao lado do design atual. A diferença deve ser óbvia em TRÊS níveis:

- **ESTRUTURA:** Top bar no tablet (não sidebar), HUD bipartido com cabeçalho de posição, leaderboard em tabela com pódio destacado
- **LINGUAGEM:** JetBrains Mono para dados numéricos, azul #2563EB como única cor vibrante (não roxo), bordas sutis ao invés de glassmorphism, geometry precisa de 8–12px
- **RIQUEZA:** SVG de rota tracejada nos cards de corrida, linha vertical de beacon no checkpoint marker, grid de largada sutil no lobby, countdown com pulso de batimento cardíaco
