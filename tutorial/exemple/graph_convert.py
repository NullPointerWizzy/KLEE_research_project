import sqlite3
import matplotlib.pyplot as plt

# Connexion à la base de données SQLite
conn = sqlite3.connect('klee-out-1/exec_tree.db')
cursor = conn.cursor()

# Exemple de requête SQL pour extraire les données
cursor.execute("SELECT colonne_x, colonne_y FROM table")

# Récupération des données
data = cursor.fetchall()
conn.close()

# Extraction des données en listes séparées
x = [row[0] for row in data]
y = [row[1] for row in data]

# Création du graphe
plt.plot(x, y)
plt.xlabel('Axe X')
plt.ylabel('Axe Y')
plt.title('Titre de votre graphe')

# Exportation du graphe en SVG
plt.savefig('graphe.svg', format='svg')

# Affichage du graphe (optionnel)
plt.show()
