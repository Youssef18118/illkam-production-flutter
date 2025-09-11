formatProvince(String name){
  if(["전라북도","전라남도","충청남도","충청북도","경상북도","경상남도"].contains(name)){
    switch(name){
      case "전라북도" : return "전북";
      case "전라남도" : return "전남";
      case "충청남도" : return "충남";
      case "충청북도" : return "충북";
      case "경상북도" : return "경북";
      case "경상남도" : return "경남";
    }
  }else{
    return name.substring(0,2);
  }
}