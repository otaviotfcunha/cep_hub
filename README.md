# Projeto de Ceps - CepHub.

Projeto de repositório de endereços e cep - Fatec 2024.<br>
<b>OBS:</b> O arquivo .env foi enviado ao professor pelo teams.

## Alunos:
- Otávio Thadeu Franklin da Cunha<br>
- Cleber Pereira dos Santos Junior<br>
- Pedro Henrique Leite dos Santos<br>

## Requisitos:
<ol>
    <li>- [x] Nome dos integrantes no readme do projeto no GitHub​</li>
    <li>- [x] Uso de uma classe de Bloc para gerenciar o estado de alguma coisa no app</li>
    <li>- [x] Organizar o projeto de acordo com as práticas mostradas em aula</li>
    <li>- [x] O aplicativo deve conter mais de uma tela</li>
    <li>- [x] O tema do aplicativo fica como escolha livre do grupo.</li>
</ol>

## Bibliotecas utilizadas:
<ol>
    <li>- [x] Back4App para armazenar os dados​</li>
    <li>- [x] Flutter_dotenv para gerenciar as api_keys</li>
    <li>- [x] Flutter_bloc para gerenciamento de estado das telas</li>
    <li>- [x] Equatable para controlar os dados de estado das telas</li>
    <li>- [x] Http para consultar os dados de cep</li>
    <li>- [x] Dio para consultar os dados da api</li>
</ol>
  
## Fluxograma:

```mermaid
graph LR
A((Inicio)) --> B[Home Page]
B -- Inserir CEP --> C{Consulta VIACEP}
C -- CEP válido --> D[Exibe o CEP na HOME]
C -- CEP inválido --> E[Trata Erros, gerencia o estado e informa usuário]
B -- Salvar CEP --> F{Gerencia o estado e verifica CEP}
F -- CEP Válido --> G[Salva/Edita CEP no Back4App]
F -- CEP Inválido ou já existe --> H[Trata erros, gerencia o estado e informa usuário]
B --> I[Lista endereços salvos]
I --> J[Editar um Endereço]
J --> F
I --> K[Excluir um Endereço]
K --> L{Verifica Dados}
L -- Dados válidos --> M[Exclui endereço no back4app]
L -- Dados inválidos --> N[Trata erros, gerencia o estado e informa usuário]
I -- Voltar --> B
```

### Minhas redes sociais, conecte-se comigo:
[![Perfil DIO](https://img.shields.io/badge/-Meu%20Perfil%20na%20DIO-30A3DC?style=for-the-badge)](https://www.dio.me/users/otavio_89908)

[![LinkedIn](https://img.shields.io/badge/-LinkedIn-000?style=for-the-badge&logo=linkedin&logoColor=30A3DC)](https://www.linkedin.com/in/ot%C3%A1vio-cunha-827560209/)

[![GitHub](https://img.shields.io/badge/-github-000?style=for-the-badge&logo=github&logoColor=30A3DC)](https://github.com/otaviotfcunha)

### Um pouco do meu GitHub:

![Top Langs](https://github-readme-stats-git-masterrstaa-rickstaa.vercel.app/api/top-langs/?username=otaviotfcunha&layout=compact&bg_color=000&border_color=30A3DC&title_color=FFF&text_color=FFF)

![GitHub Stats](https://github-readme-stats.vercel.app/api?username=otaviotfcunha&theme=transparent&bg_color=000&border_color=30A3DC&show_icons=true&icon_color=30A3DC&title_color=FFF&text_color=FFF)


