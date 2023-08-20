import os
import matplotlib.pyplot as plt
import pandas as pd
import markdown


if os.path.isfile('analyse.md'):
    os.remove('analyse.md')

if not os.path.isdir('plots'):
    os.mkdir('plots')
else:
    for file in os.listdir('plots'):
        os.remove('plots/' + file)


data = pd.read_csv('data.csv')
data = data.drop_duplicates(keep='first')
data['last_update'] = pd.to_datetime(data['last_update'])

for name in data['name'].unique():
    plt.scatter(data[data['name'] == name]['last_update'], data[data['name'] == name]['wait_time'], label='Wait Time')
    plt.title(name)
    plt.xlabel('Tijd')
    plt.xticks(rotation=90)
    plt.ylabel('Wachttijd (minuten)')
    plt.tight_layout()
    plt.savefig('plots/' + name.replace("'", "").replace(" ", "_").replace("#", "") + '.png')
    plt.clf()


    #plt.plot(data[data['name'] == name]['last_update'], data[data['name'] == name]['wait_time'], label='Wait Time')
    #plt.title(name)
    #plt.xlabel('Tijd')
    #plt.ylabel('Wachttijd (minuten)')
    #plt.savefig('plots/' + name.replace("'", "").replace(" ", "_").replace("#", "") + '_line.png')
    #plt.clf()

    if not os.path.isfile('analyse.md'):
        with open('analyse.md', 'w') as analyse:
            analyse.write('# Analyse voor de wachttijden van attracties in Plopsaland\n\n ')
            analyse.write('Dit is een automatisch gegenereerd bestand, veranderingen zullen worden overschreven\n\n ')
            analyse.write('Dit bestand is gemaakt op ' + str(pd.to_datetime('today').strftime('%d/%m/%Y')) + " om " + str(pd.to_datetime('today').strftime('%H:%M:%S')) + '\n\n ')
            analyse.write('<h2> Attracties</h2> \n\n')
    with open('analyse.md', 'a') as analyse:
        analyse.write('<h3> ' + name + '</h3>\n')
        image_path = os.path.relpath('plots/' + name.replace("'", "").replace(" ", "_").replace("#", "") + '.png')

        analyse.write('Gemiddelde wachttijd: ' + str(round(data[data['name'] == name]['wait_time'].mean(),2)).replace(".", ",") + ' minuten<br> ')

        analyse.write('Mediaan wachttijd: ' + str(data[data['name'] == name]['wait_time'].median()).replace(".",",") + ' minuten<br> ')
        analyse.write('Standaard deviatie: ' + str(round(data[data['name'] == name]['wait_time'].std(),2)).replace(".", ",") + ' minuten<br> ')

        analyse.write('<img src="' + image_path + '">\n')
with open("analyse.md") as md:
        with open("rapport.html", 'w') as htmlfile:
            html=markdown.markdown(md.read())
            htmlfile.write(html)
            htmlfile.close()