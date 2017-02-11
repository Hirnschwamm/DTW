
function hz = mel2hz_transform(mel)

hz = ( 1000*(exp((log(2)*mel)/1000)-1) );