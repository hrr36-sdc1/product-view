#!/bin/bash
#!/usr/bin/env node

start=`date +%s`

# generate data files
numseeds=1
N=12000000
for i in `seq 1 $numseeds`;
do
  N=$N node ./database/utils/generate_products.js
  N=$N node ./database/utils/generate_images.js
  echo image seed $i generated
done

# load data files into postgres and cassandra
for i in `seq 1 $numseeds`;
do
  psql -U postgres -d products -c "\copy shoes(colors, type, model, sizes, price, image_id, review_count, avg_stars) from ./database/utils/seeds/productfile.csv delimiter ',' csv header;"
  psql -U postgres -d products -c "\copy images(links) from ./database/utils/seeds/imagefile.csv delimiter ',' csv header;"
 echo seed $i loaded
done

# cleanup
for i in `seq 1 $numseeds`;
do
  rm ./database/utils/seeds/productfile.csv
  rm ./database/utils/seeds/imagefile.csv
  echo seed $i removed
done

# cleanup
rm import*.err*

# log script runtime
end=`date +%s`
runtime=$((end-start))
echo $runtime