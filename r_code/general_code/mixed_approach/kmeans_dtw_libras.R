

# Applying hierarchical clustering with DTW distance to the dataset Libras 

# Loading and preparing the data 

libras <- read.csv('libras.txt', header = F)
colnames(libras) <- NULL
S <- vector(mode = "list", length = nrow(libras))

for (i in 1 : length(S)) {
  S1 <- libras[i, c(seq(1, 90, by = 2), 91)] 
  S2 <- libras[i, c(seq(2, 90, by = 2), 91)]
  S[[i]] <- rbind(as.numeric(S1), as.numeric(S2))
}

M <- vector(mode = "list", length = length(S))
for (i in 1:length(S)) {
  M[[i]] <- t(S[[i]][,seq(1, 45)])
}

# Ground truth 

ground_truth <- numeric(length(M))
for (j in 1 : length(M)) {
  ground_truth[j] <- S[[j]][1, 46]
}

# k-means clustering

clustering <- km_mts(M, 15, dis = dtw_mts)
external_validation(ground_truth, clustering)

# Hierarchical clustering 


d_matrix <- matrix(0, 360, 360)

for (i in 1 : 360) {
  for (j in 1 : 360) {
    d_matrix[i, j] <- dtw_mts(M[[i]], M[[j]])
  }
}

hierarchical <- hclust(dist(d_matrix))
plot(hierarchical)
clustering <- cutree(hierarchical, 20)
external_validation(ground_truth, clustering) # External validation of hierarchical clustering 