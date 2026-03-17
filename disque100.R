#--------------------------------------------------------------------------------
#- Script Produto 3
#--------------------------------------------------------------------------------
# Obj: Analise banco "Disque Direitos Humanos do Ministério dos Direitos Humanos e da Cidadania"
#
# Autora: Maria Julia Neves Gregorio
#         03-mar-2025
#--------------------------------------------------------------------------------

#--------------------------------------------------------------------------------
#- Pacotes
#--------------------------------------------------------------------------------

library(dplyr)
library(ggplot2)

#--------------------------------------------------------------------------------
#- Leitura dos dados e seleção de variaveis de interesse
#--------------------------------------------------------------------------------
setwd("C:/Users/Usuário/Desktop/Produto3")
dados2 <- read.csv("disque100-segundo-semestre-2025.csv", sep = ";")
dados2 <- dados2 %>% filter(UF == "PE")

dados2 %>% names
dados2 <- dados2 %>% select(-hash, -Data_de_cadastro, -Canal_de_atendimento, -País, -UF)

head(dados2$Município)

dados2 <- dados2 %>%
  mutate(Municipio_nome = sub(".*\\| ", "", Município))

dados2 <- dados2 %>%
  select(
    # território
    Municipio_nome,
    
    # tipo de violência
    Grupo_vulnerável,
    violacao,
    
    # dinâmica da violência
    Cenário_da_violação,
    Frequência,
    Início_das_violações,
    
    # gravidade
    Denúncia_emergencial,
    sl_quantidade_vitimas,
    
    # perfil da vítima
    Orientação_sexual_da_vítima,
    Faixa_etária_da_vítima,
    Gênero_da_vítima,
    Raça_Cor_da_vítima,
    Deficiência_da_vítima,
    Faixa_de_renda_da_vítima,
    Grau_de_instrução_da_vítima,
    
    # dinâmica vítima-suspeito
    Relação_vítima_suspeito
  )

#--------------------------------------------------------------------------------
#- Escolha do município de interesse 
#--------------------------------------------------------------------------------

Mun <- c("BEZERROS")
dados <- dados2 %>% filter(Municipio_nome == Mun)
colSums(is.na(dados))

sapply(dados, function(x) {
  sum(is.na(x) | x %in% c("NA","NULL", "NÃO INFORMADO", "IGNORADO", ""))
})

dados <- dados %>% select(-Grau_de_instrução_da_vítima, -Deficiência_da_vítima, -Faixa_de_renda_da_vítima)

#--------------------------------------------------------------------------------
#- Indicador Número de denúncias por 100 mil habitantes 
#--------------------------------------------------------------------------------

library(sidrar)
library(dplyr)

pop_ibge <- get_sidra(
  x = 6579,
  variable = 9324,
  period = "2025",                  # troque por 2024, 2021, etc. (anos disponíveis no info_sidra)
  geo = "City",
  geo.filter = list("State" = 26),  # Pernambuco
  classific = "all"
) %>%
  transmute(
    code_muni = as.integer(`Município (Código)`),
    populacao = Valor
  )

populacao <- pop_ibge[pop_ibge$code_muni== 2601904,2]
denuncia <- nrow(dados)

taxa <- (denuncia/populacao) * 100000
taxa

#--------------------------------------------------------------------------------
#- tipos de violência denunciados
#--------------------------------------------------------------------------------

dados %>% names

levels(as.factor(dados$Grupo_vulnerável))
head(dados$violacao)

library(ggplot2)
library(dplyr)
library(scales)

# 1. Preparando os dados com quebra de linha automática para nomes longos
dados_plot <- dados %>%
  count(Grupo_vulnerável) %>%
  mutate(
    # Quebra o texto se tiver mais de 25 caracteres para não poluir a lateral
    Grupo_vulnerável = stringr::str_wrap(Grupo_vulnerável, width = 25)
  )

# 2. O Gráfico
ggplot(dados_plot, aes(x = reorder(Grupo_vulnerável, n), y = n)) +
  # Barras com uma cor sólida mais elegante (Slate Blue) e largura ajustada
  geom_col(fill = "#4682B4", width = 0.7) + 
  # Rótulos de dados brancos dentro da barra ou pretos fora
  geom_text(
    aes(label = n), 
    hjust = -0.3, # Posiciona um pouco à frente da barra
    size = 4.5, 
    fontface = "bold", 
    color = "#333333"
  ) +
  coord_flip() +
  # Remove o espaço vazio entre a barra e o nome do grupo
  scale_y_continuous(expand = expansion(mult = c(0, .15))) +
  labs(
    title = "Denúncias por Tipo de Violência",
    subtitle = "Total de registros consolidados por grupo vulnerável",
    caption = "Fonte: Disque 100 | Segundo semestre 2025",
    x = NULL,
    y = NULL
  ) +
  # Tema customizado do zero
  theme_minimal(base_size = 14) +
  theme(
    # Título alinhado à esquerda e em destaque
    plot.title = element_text(face = "bold", size = 20, color = "#1a1a1a", margin = margin(b = 5)),
    plot.subtitle = element_text(size = 12, color = "#666666", margin = margin(b = 20)),
    
    # Limpeza total dos eixos e grades
    axis.text.x = element_blank(), # Remove números de baixo
    axis.ticks = element_blank(),
    panel.grid.major = element_blank(), # Remove todas as linhas de grade
    panel.grid.minor = element_blank(),
    
    # Ajuste do texto lateral (Y)
    axis.text.y = element_text(size = 11, color = "#2c3e50", face = "bold", lineheight = 0.9),
    
    # Fundo e Margens
    plot.background = element_rect(fill = "white", color = NA),
    plot.margin = margin(25, 25, 25, 25)
  )

head(dados$violacao)
library(tidyr)

# Separando a violacao em subcategorias
dados <- dados %>%
  separate(violacao,
           into = c("categoria", "tipo", "subtipo"),
           sep = ">")

# 1. Gráfico: Natureza da Violência (Macro)
dados %>%
  filter(!is.na(tipo), tipo != "NA") %>% # Limpeza de NAs
  count(tipo) %>%
  ggplot(aes(x = reorder(tipo, n), y = n)) +
  geom_col(fill = "#4682B4", width = 0.7) + 
  geom_text(aes(label = n), hjust = -0.3, size = 4.5, fontface = "bold", color = "#333333") +
  coord_flip() +
  scale_y_continuous(expand = expansion(mult = c(0, .15))) +
  labs(
    title = "Natureza das Violações Registradas",
    subtitle = "Distribuição por categoria principal de violência",
    caption = "Fonte: Disque 100 | Segundo semestre 2025",
    x = NULL, y = NULL
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18, color = "#1a1a1a"),
    panel.grid = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_text(face = "bold", color = "#2c3e50")
  )

# 2. Gráfico: Top 10 Detalhamento da Violência
dados %>%
  filter(!is.na(subtipo), subtipo != "NA") %>%
  count(subtipo) %>%
  slice_max(n, n = 10) %>%
  ggplot(aes(x = reorder(subtipo, n), y = n)) +
  geom_col(fill = "#4682B4", width = 0.7) + 
  geom_text(aes(label = n), hjust = -0.3, size = 4, fontface = "bold") +
  coord_flip() +
  scale_y_continuous(expand = expansion(mult = c(0, .15))) +
  labs(
    title = "Top 10 Tipos Específicos",
    subtitle = "Detalhamento das violações mais frequentes no município",
    x = NULL, y = NULL
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    panel.grid = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_text(size = 10, face = "bold")
  )

# 3. Gráfico: Natureza da Violência por Grupo Vulnerável
dados %>%
  filter(!is.na(tipo), tipo != "NA") %>%
  # Quebra de linha nos nomes dos grupos para não esmagar o gráfico
  mutate(Grupo_vulnerável = stringr::str_wrap(Grupo_vulnerável, width = 20)) %>%
  count(Grupo_vulnerável, tipo) %>%
  ggplot(aes(x = reorder(tipo, n), y = n)) +
  geom_col(fill = "#4682B4") +
  facet_wrap(~Grupo_vulnerável, scales = "free_y") + # Cria um gráfico para cada grupo
  coord_flip() +
  labs(
    title = "Perfil de Violência por Grupo",
    subtitle = "Comparativo da natureza da agressão entre diferentes públicos",
    x = NULL, y = "Número de denúncias"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    strip.text = element_text(face = "bold", color = "white"), # Título dos quadradinhos
    strip.background = element_rect(fill = "#2c3e50"),
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", size = 18)
  )

#--------------------------------------------------------------------------------
#- Perfil da vítima
#--------------------------------------------------------------------------------

# 1. Definir a ordem cronológica (mais novos na base)
ordem_idades <- c(
  "RECÉM-NASCIDO (ATÉ 28 DIAS)", 
  "MENOS DE 01 ANO", "04 ANOS", "05 ANOS", "07 ANOS", 
  "11 ANOS", "12 ANOS", "13 ANOS", "14 ANOS", "15 ANOS", "16 ANOS",
  "30 A 34 ANOS", "35 A 39 ANOS", "40 A 44 ANOS", "45 A 49 ANOS", 
  "55 A 59 ANOS", "60 A 64 ANOS", "65 A 69 ANOS", "70 A 74 ANOS", 
  "75 A 79 ANOS", "80 A 84 ANOS", "85 A 89 ANOS", "90+"
)

# 2. Sumarizar e depois aplicar a transformação
dados_piramide <- dados %>%
  # Primeiro filtramos e limpamos
  filter(Gênero_da_vítima %in% c("MASCULINO", "FEMININO"),
         Faixa_etária_da_vítima %in% ordem_idades) %>%
  # Agora contamos (isso cria a coluna 'n')
  count(Faixa_etária_da_vítima, Gênero_da_vítima) %>%
  # Agora o mutate vai funcionar porque o 'n' já existe
  mutate(
    Faixa_etária_da_vítima = factor(Faixa_etária_da_vítima, levels = ordem_idades),
    n_plot = ifelse(Gênero_da_vítima == "MASCULINO", -n, n)
  )

# 3. Gerar o gráfico
ggplot(dados_piramide, aes(x = Faixa_etária_da_vítima, y = n_plot, fill = Gênero_da_vítima)) +
  geom_col(width = 0.8) +
  coord_flip() +
  scale_y_continuous(labels = abs, expand = expansion(mult = c(0.1, 0.1))) +
  scale_fill_manual(values = c("MASCULINO" = "#4682B4", "FEMININO" = "#E34A33")) +
  labs(
    title = "Perfil Demográfico das Vítimas",
    subtitle = "Distribuição cronológica por faixa etária e gênero (Bezerros - PE)",
    x = NULL, y = "Número de Vítimas",
    fill = "Gênero"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    legend.position = "bottom"
  )

# 2. Distribuição por Raça/Cor
dados %>%
  filter(!Raça_Cor_da_vítima %in% c("NÃO INFORMADO", "IGNORADO", "NA")) %>%
  count(Raça_Cor_da_vítima) %>%
  ggplot(aes(x = reorder(Raça_Cor_da_vítima, n), y = n)) +
  geom_col(fill = "#4682B4", width = 0.7) +
  geom_text(aes(label = n), hjust = -0.3, size = 4.5, fontface = "bold") +
  coord_flip() +
  scale_y_continuous(expand = expansion(mult = c(0, .15))) +
  labs(
    title = "Perfil Étnico-Racial",
    subtitle = "Distribuição das vítimas por raça/cor declarada",
    x = NULL, y = NULL
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    panel.grid = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_text(face = "bold")
  )



#--------------------------------------------------------------------------------
#- relação entre vítima e agressor
#--------------------------------------------------------------------------------

# 1. Gráfico: Top 10 Relações (Geral)
dados %>%
  filter(!Relação_vítima_suspeito %in% c("NÃO INFORMADO", "NÃO SE APLICA", "NA", "DESCUNHECIDO(A)")) %>%
  count(Relação_vítima_suspeito) %>%
  slice_max(n, n = 10) %>%
  ggplot(aes(x = reorder(Relação_vítima_suspeito, n), y = n)) +
  geom_col(fill = "#4682B4", width = 0.7) +
  geom_text(aes(label = n), hjust = -0.3, size = 4.5, fontface = "bold") +
  coord_flip() +
  scale_y_continuous(expand = expansion(mult = c(0, .15))) +
  labs(
    title = "Principais Vínculos do Suspeito",
    subtitle = "Top 10 relações entre vítima e agressor nas denúncias",
    x = NULL, y = NULL
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    panel.grid = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_text(face = "bold")
  )

# 2. Gráfico: Quem agride quem? (Cruzamento por Grupo)
dados %>%
  filter(!Relação_vítima_suspeito %in% c("NÃO INFORMADO", "NÃO SE APLICA", "NA"),
         !is.na(Grupo_vulnerável)) %>%
  # Pegamos os 5 agressores mais comuns por grupo para não poluir
  group_by(Grupo_vulnerável) %>%
  count(Relação_vítima_suspeito) %>%
  slice_max(n, n = 5) %>%
  ungroup() %>%
  mutate(Grupo_vulnerável = stringr::str_wrap(Grupo_vulnerável, width = 20)) %>%
  ggplot(aes(x = reorder(Relação_vítima_suspeito, n), y = n)) +
  geom_col(fill = "#4682B4") +
  facet_wrap(~Grupo_vulnerável, scales = "free_y") +
  coord_flip() +
  labs(
    title = "Perfil do Agressor por Público",
    subtitle = "Os 5 vínculos mais comuns em cada grupo vulnerável",
    x = NULL, y = "Número de denúncias"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    strip.text = element_text(face = "bold", color = "white"),
    strip.background = element_rect(fill = "#2c3e50"),
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", size = 18)
  )


#--------------------------------------------------------------------------------
#- cenários de ocorrência das violações
#--------------------------------------------------------------------------------

# Gráfico: Onde a violência ocorre
dados %>%
  filter(!is.na(Cenário_da_violação)) %>%
  count(Cenário_da_violação) %>%
  slice_max(n, n = 7) %>% # Foco nos 7 cenários principais
  ggplot(aes(x = reorder(Cenário_da_violação, n), y = n)) +
  geom_col(fill = "#4682B4", width = 0.7) +
  geom_text(aes(label = n), hjust = -0.3, size = 4.5, fontface = "bold") +
  coord_flip() +
  scale_y_continuous(expand = expansion(mult = c(0, .15))) +
  labs(
    title = "Cenários de Ocorrência",
    subtitle = "Locais com maior incidência de denúncias registrados",
    x = NULL, y = NULL
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    panel.grid = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_text(face = "bold", size = 10)
  )

dados %>%
  count(Cenário_da_violação) %>%
  mutate(
    percentual = round(100 * n / sum(n), 1)
  ) %>%
  arrange(desc(n))

