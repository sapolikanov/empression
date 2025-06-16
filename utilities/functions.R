# functions.R

# functions shared across scripts are placed here

clean_land_column_name <- function(name) {
  # Lowercase and trim whitespace
  name <- tolower(name)
  name <- gsub("\\s+", " ", name)
  name <- trimws(name)
  
  # Remove suffixes like "des." or "desiatin" etc.
  name <- gsub(" des\\.?| desiatin[s]?\\.?| rub\\.?| rubles?", "", name)
  
  # Extract category (assumes starts with n_owners, land_areas, or rents)
  category <- ifelse(grepl("^n_owners", name), "n_owners",
                     ifelse(grepl("^land_areas", name), "land_areas",
                            ifelse(grepl("^rents", name), "rents", NA)))
  
  # Extract estate
  estate <- NA
  estate_patterns <- c(
    "nobility" = "nobility",
    "clergy" = "clergy",
    "merchants" = "merchants",
    "townsmen" = "townsmen",
    "peasants \\(private\\)" = "peasants_excl_communes",
    "peasants \\(no communes\\)" = "peasants_excl_communes",
    "peasants \\(including communes\\)" = "peasants_incl_communes",
    "peasants \\(with communes\\)" = "peasants_incl_communes",
    "peasants \\(only communes\\)" = "peasants_communes_only",
    "all private owners" = "all",
    "all" = "all"
  )
  
  for (pattern in names(estate_patterns)) {
    if (grepl(pattern, name)) {
      estate <- estate_patterns[[pattern]]
      break
    }
  }
  
  # Extract land size range
  range <- NA
  if (grepl("priv < ?10", name)) {
    range <- "priv_lt_10"
  } else if (grepl("priv > ?10000", name)) {
    range <- "priv_gt_10000"
  } else if (grepl("\\d+ ?[-to]{1,3} ?\\d+", name)) {
    range <- gsub(" ", "_", regmatches(name, regexpr("\\d+ ?[-to]{1,3} ?\\d+", name)))
    range <- gsub("-", "_", range)
    range <- gsub("to", "_", range)
  }
  
  # Build standardized name
  if (!is.na(category) && !is.na(estate) && !is.na(range)) {
    return(paste(category, estate, range, sep = "."))
  } else {
    return(name)  # Return unchanged if doesn't match pattern
  }
}

extract_parts <- function(var) {
  parts <- unlist(str_split(var, "\\."))
  tibble(
    category = parts[1],
    estate   = parts[2],
    bracket  = parts[3]
  )
}

bracket_midpoints <- function(b) {
  if (is.na(b)) return(NA_real_)
  if (b == "priv_lt_10") return(5)
  if (b == "priv_gt_10000") return(12500)
  
  # Clean up multiple underscores and extract numbers
  b <- gsub("priv", "", b)
  b <- gsub("_+", "_", b)              # collapse repeated underscores
  b <- gsub("^_|_$", "", b)            # trim leading/trailing _
  parts <- unlist(str_split(b, "_"))
  
  # Only compute mean if exactly two numbers
  nums <- suppressWarnings(as.numeric(parts))
  if (length(nums) == 2 && all(!is.na(nums))) {
    return(mean(nums))
  } else {
    return(NA_real_)
  }
}

compute_gini <- function(df) {
  df <- df |>
    filter(!is.na(total_owners), !is.na(total_land)) |>
    arrange(midpoint) |>
    mutate(
      pop_share = total_owners / sum(total_owners),
      land_share = total_land / sum(total_land),
      cum_pop = cumsum(pop_share),
      cum_land = cumsum(land_share),
      cum_pop_lag = lag(cum_pop, default = 0),
      cum_land_lag = lag(cum_land, default = 0)
    )
  
  1 - sum((df$cum_land + df$cum_land_lag) * (df$cum_pop - df$cum_pop_lag))
}
