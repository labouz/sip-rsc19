library(shinyloadtest)

# -------------------
# Pre-Run Checklist!
# -------------------

# [] In use_models.R, un-comment the set.seed call on line 52
# [] Redeploy your app to RStudio Connect
# [] Make sure your app's access is set to "Anyone - no login"
# [] Record the (...) -> Open Solo URL for your app (line 18 below)
# [] Log out of RStudio Connect 

# -------------------
# Steps to Run
# -------------------

# replace with the (...) -> Open Solo URL for your app
deployed_app_url <- 'REPLACE ME'

# first record our app:
# 1) Run this command
# 2) Interact with the app as the user would (pause to view understand the results)
# 3) Browse for at least 3 minutes
# 4) Close the tab
record_session(deployed_app_url)


# run our first baseline load test
cmd <- glue::glue(
  "shinycannon recording.log {deployed_app_url} --workers 1 --loaded-duration-minutes 5 --output-dir baseline"
)
rstudioapi::terminalExecute(
  cmd,
  show = TRUE
)

# run our second 25 user test
cmd <- glue::glue(
  "shinycannon recording.log {deployed_app_url} --workers 25 --loaded-duration-minutes 5 --output-dir twentyfive"
)
rstudioapi::terminalExecute(
  cmd,
  show = TRUE
)
 
# compare results
loadtest <- load_runs(
  baseline = "baseline",
  twentyfive = "twentyfive"
)

shinyloadtest_report(loadtest)

# ----------
# STOP 
# We will update our app to use renderCachedPlot
# ----------

# ----------
# Pre-Run Checklist
# ----------

# [] Did you redeploy your app?
# [] Are you still logged out of RStudio Connect?


# run our second 25 user test with the cache'd version
cmd <- glue::glue(
  "shinycannon recording.log {deployed_app_url} --workers 25 --loaded-duration-minutes 5 --output-dir cached"
)
rstudioapi::terminalExecute(
  cmd,
  show = TRUE
)

# compare new results again
loadtest <- load_runs(
  baseline = "baseline",
  twentyfive = "twentyfive", 
  cached_twentyfive = "cached"
)

shinyloadtest_report(loadtest)

#----------
# STOP 
# We will update the RSC runtime settings for our app
#----------

# ----------
# Pre-Run Checklist
# ----------

# [] Did you update your settings?
# []Log out of RStudio Connect again... (I know, I know)


# run our third 25 user test with the cache'd version & more R procs
cmd <- glue::glue(
  "shinycannon recording.log {deployed_app_url} --workers 25 --loaded-duration-minutes 5 --output-dir scaled"
)
rstudioapi::terminalExecute(
  cmd,
  show = TRUE
)

# compare new results again
loadtest <- load_runs(
  baseline = "baseline",
  twentyfive = "twentyfive", 
  cached_twentyfive = "cached",
  scaled_twentyfive = "scaled"
)

shinyloadtest_report(loadtest)
