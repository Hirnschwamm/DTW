function mel = hz2mel_transform(hz)

mel = ( 1000/log(2)*log(1+hz/1000) ); 