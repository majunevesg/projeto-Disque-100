# 📊 Análise de Dados: Disque 100 – Direitos Humanos (Bezerros/PE)

> **Análise exploratória das denúncias de violações de direitos humanos registradas no 2º semestre de 2025.**

Este projeto apresenta um diagnóstico detalhado das denúncias captadas pelo **Disque 100**, canal do Governo Federal para o recebimento de violações de direitos humanos. O foco da análise concentra-se no município de **Bezerros, Pernambuco**, transformando dados brutos em indicadores para o entendimento da dinâmica social local.

---

## 🎯 Objetivos da Análise

Diferente de registros criminais estritos, o Disque 100 funciona como um **indicador antecedente**, captando violências antes mesmo de se tornarem boletins de ocorrência. Esta análise busca responder:

* Quais **grupos vulneráveis** (Crianças, Idosos, LGBTQIA+, etc.) concentram mais denúncias?
* Quais são as **naturezas de violação** mais frequentes na região?
* Como os dados podem apoiar **políticas públicas de prevenção** e diagnósticos sociais?

---

## 🛠️ Ferramentas Utilizadas

O projeto foi desenvolvido inteiramente em **R**, utilizando as seguintes bibliotecas:

* `tidyverse` (Manipulação e visualização)
* `dplyr` & `readr` (Processamento de dados)
* `ggplot2` (Gráficos e visualizações)
* `RMarkdown` (Documentação e relatórios)

---

## 📂 Metodologia e Dados

Os dados brutos foram obtidos através do portal de [Dados Abertos do MDH](https://www.gov.br/mdh/pt-br/acesso-a-informacao/dados-abertos/disque100).

* **Recorte Temporal:** 2º Semestre de 2025.
* **Volume Original:** ~2,4 milhões de observações e 62 variáveis.
* **Tratamento:** Filtragem específica para o estado de **Pernambuco** e o município de **Bezerros**.

> [!IMPORTANT]
> **Nota Metodológica:** Os dados refletem denúncias registradas e estão sujeitos a subnotificação. Como dependem da propensão à denúncia, não devem ser interpretados como uma medida absoluta da criminalidade, mas sim como um termômetro da percepção e incidência de violações relatadas.

---

## 📊 Estrutura do Projeto

1.  **Coleta e Limpeza:** Script para importação dos dados governamentais e aplicação de filtros geográficos.
2.  **Análise Descritiva:** Identificação de padrões por tipo de vítima e tipo de violação.
3.  **Visualização:** Geração de gráficos para facilitar a interpretação dos dados por gestores públicos.
4.  **Conclusão:** Síntese dos achados e recomendações.

---

## 🚀 Próximos Passos

* [ ] **Análise Espacial:** Realizar análise conjunta de cidades vizinhas do Agreste para identificar clusters de violência.
* [ ] **Cruzamento de Dados:** Comparar os índices do Disque 100 com indicadores socioeconômicos (IDH/IBGE).

---

## 🔗 Referências

* [Ministério dos Direitos Humanos e da Cidadania - Dados Abertos](https://www.gov.br/mdh/pt-br/acesso-a-informacao/dados-abertos/disque100)






















