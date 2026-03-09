# 📊 Análise de Dados do Disque 100 – Violações de Direitos Humanos

Este projeto apresenta uma **análise exploratória de dados das denúncias registradas no Disque 100**, canal do Governo Federal destinado ao recebimento de denúncias de violações de direitos humanos no Brasil.

O objetivo é **identificar padrões, grupos vulneráveis e tipos de violações mais frequentes**, contribuindo para o entendimento da dinâmica dessas ocorrências e para o desenvolvimento de políticas públicas baseadas em evidências.

---

## 📚 Sobre o Disque 100

O **Disque 100** é um serviço nacional de denúncias que recebe registros de violações relacionadas a diferentes grupos vulneráveis, como:

- Crianças e adolescentes  
- Pessoas idosas  
- Pessoas com deficiência  
- População LGBTQIA+  
- População em situação de rua  
- Mulheres  

As denúncias podem ser realizadas **anonimamente** e são encaminhadas para órgãos responsáveis pela apuração.

Fonte: Ministério dos Direitos Humanos e da Cidadania.

---

## 🎯 Objetivos da análise

Este projeto busca responder perguntas como:

- Quais **grupos vulneráveis** concentram mais denúncias?
- Quais são os **tipos de violação mais frequentes**?
- Como as denúncias se distribuem **geograficamente**?
- Existem padrões relevantes que possam apoiar **diagnósticos sociais ou políticas públicas**?

---

## 🛠️ Ferramentas utilizadas

- **R**
- **tidyverse**
- **ggplot2**
- **dplyr**
- **readr**
- **RMarkdown**

---

## 📊 Exemplos de análises realizadas

- Distribuição das denúncias por **grupo vulnerável**
- Frequência dos **tipos de violação**
- Análise exploratória das variáveis disponíveis
- Visualização gráfica das ocorrências

---

## 📂 Estrutura do projeto

## Coleta de dados e limpeza dos dados

Os dados estão disponiveis no site do gov e podem ser obtidos semestralmente. Os dados dessa estudo em questão foram obtidos utilizando o segundo semestre de 2025.
O banco de dados possui 2421688 observações e 62 variáveis. Inicialmente filtramos o estado Pernambuco e posteriormente escolhemos a cidade de Bezerros para esta análise.

dá para tirar muita coisa útil do Disque 100, especialmente para um relatório de prevenção da violência. 
Na verdade, ele pode ser uma das melhores bases complementares, porque capta violência antes de virar crime registrado ou morte.
Lembrando que não é possivel fazer inferencias sobre esses dados, uma vez que
Os dados refletem denúncias registradas e podem estar sujeitos a subnotificação e variações na propensão à denúncia.

## Análise descritiva

## Conclusão

## Próximos passos

Pode ser interessante fazer a analise conjnta de algumas cidades e dessa maneira fazer uma analise espacial

## Referências

https://www.gov.br/mdh/pt-br/acesso-a-informacao/dados-abertos/disque100
























