library(shiny)
library(httr2)
library(jsonlite)
library(tidyverse)
library(bslib)
library(DT)

# Definition de l'interface utilisateur
ui <- page_sidebar(
  theme = bs_theme(bootswatch = "minty", primary = "#2ecc71"),
  title = "Nutri-Eco Intelligence Dashboard",
  
  # Barre latérale pour la recherche
  sidebar = sidebar(
    title = "Data Acquisition",
    textInput("query", "Requête API :", value = "oreo"),
    actionButton("go", "Analyser la donnée", icon = icon("microchip"), class = "btn-primary w-100"),
    hr(),
    helpText("Analyse multidimensionnelle : Nutriscore, Ecoscore et NOVA.")
  ),
  
  # Affichage des compteurs principaux (KPIs)
  layout_column_wrap(
    width = 1/4, gap = "15px",
    value_box(title = "Volume Data Total", value = textOutput("total_count"), showcase = icon("database"), theme = "primary"),
    value_box(title = "Nutri-Score Mode", value = textOutput("avg_nutri"), showcase = icon("heart-pulse"), theme = "info"),
    value_box(title = "Eco-Score Mode", value = textOutput("avg_eco"), showcase = icon("leaf"), theme = "success"),
    value_box(title = "Taux Ultra-Transformé", value = textOutput("nova_rate"), showcase = icon("industry"), theme = "danger")
  ),
  
  # Section des graphiques
  layout_column_wrap(
    width = 1/2, gap = "20px",
    card(card_header("Analyse Bivariée"), card_body(plotOutput("crossPlot"))),
    card(card_header("Profil NOVA"), card_body(plotOutput("novaPlot")))
  ),
  
  # Tableau de données brut
  card(card_header("Dataset Structuré"), card_body(DTOutput("tableAPI")))
)

server <- function(input, output) {
  
  # Récupération des données sur l'API Open Food Facts
  raw_data <- eventReactive(input$go, {
    req_url <- paste0("https://world.openfoodfacts.org/cgi/search.pl?search_terms=", 
                      URLencode(input$query), "&search_simple=1&action=process&json=1&page_size=100")
    
    # Sécurité pour éviter les erreurs de connexion
    tryCatch({
      resp <- request(req_url) %>% req_perform()
      res_json <- resp %>% resp_body_json()
      return(res_json)
    }, error = function(e) return(NULL))
  }, ignoreNULL = FALSE)
  
  # Nettoyage et mise en forme des données reçues
  processed_df <- reactive({
    data <- raw_data()
    if (is.null(data) || length(data$products) == 0) return(NULL)
    
    # On crée un tableau propre avec les colonnes qui nous intéressent
    df <- map_df(data$products, ~{
      list(
        Nom = as.character(.x$product_name %||% "Inconnu"),
        Marque = as.character(.x$brands %||% "Inconnue"),
        Nutri = toupper(as.character(.x$nutriscore_grade %||% "N/A")),
        Eco = toupper(as.character(.x$ecoscore_grade %||% "N/A")),
        Nova = as.numeric(.x$nova_group %||% NA)
      )
    })
    return(df)
  })
  
  # Affichage du nombre total de produits trouvés en base
  output$total_count <- renderText({
    data <- raw_data()
    if(is.null(data)) return("0")
    return(as.character(format(data$count, big.mark = " ")))
  })
  
  # Calcul du Nutri-Score le plus fréquent
  output$avg_nutri <- renderText({
    df <- processed_df()
    if(is.null(df)) return("-")
    valid_df <- df %>% filter(Nutri %in% c("A","B","C","D","E"))
    if(nrow(valid_df) == 0) return("N/A")
    res <- valid_df %>% count(Nutri) %>% slice_max(n, n = 1, with_ties = FALSE)
    return(as.character(res$Nutri[1]))
  })
  
  # Calcul de l'Eco-Score le plus fréquent
  output$avg_eco <- renderText({
    df <- processed_df()
    if(is.null(df)) return("-")
    valid_df <- df %>% filter(Eco %in% c("A","B","C","D","E"))
    if(nrow(valid_df) == 0) return("N/A")
    res <- valid_df %>% count(Eco) %>% slice_max(n, n = 1, with_ties = FALSE)
    return(as.character(res$Eco[1]))
  })
  
  # Calcul du pourcentage de produits ultra-transformés (Nova 4)
  output$nova_rate <- renderText({
    df <- processed_df()
    if(is.null(df)) return("0%")
    nova4 <- sum(df$Nova == 4, na.rm = TRUE)
    total <- sum(!is.na(df$Nova))
    if(total == 0) return("0%")
    return(paste0(round((nova4/total)*100, 1), "%"))
  })
  
  # Graphique croisant Nutri-Score et Eco-Score
  output$crossPlot <- renderPlot({
    df <- processed_df()
    if(is.null(df)) return(NULL)
    df_plot <- df %>% filter(Nutri %in% LETTERS[1:5], Eco %in% LETTERS[1:5])
    if(nrow(df_plot) == 0) return(NULL)
    
    ggplot(df_plot, aes(x = Nutri, y = Eco)) +
      geom_count(color = "#2ecc71") +
      theme_minimal() +
      labs(x = "Nutri-Score", y = "Eco-Score", size = "Effectif")
  })
  
  # Graphique en barres pour la répartition NOVA
  output$novaPlot <- renderPlot({
    df <- processed_df()
    if(is.null(df)) return(NULL)
    df_nova <- df %>% filter(!is.na(Nova))
    if(nrow(df_nova) == 0) return(NULL)
    
    ggplot(df_nova, aes(x = factor(Nova), fill = factor(Nova))) +
      geom_bar() +
      scale_fill_manual(values = c("1"="#2ecc71", "2"="#f1c40f", "3"="#e67e22", "4"="#e74c3c")) +
      theme_minimal() + labs(x = "Score NOVA", y = "Nombre", fill = "Groupe")
  })
  
  # Rendu du tableau de données interactif
  output$tableAPI <- renderDT({
    df <- processed_df()
    if(is.null(df)) return(datatable(data.frame(Info = "Aucune donnée")))
    datatable(df, options = list(pageLength = 10, dom = 'ftp'), rownames = FALSE)
  })
}

shinyApp(ui, server)