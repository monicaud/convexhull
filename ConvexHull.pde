
ArrayList<Edge> edges2 = new ArrayList<Edge>();
Polygon ConvexHullGiftWrapped( ArrayList<Point> points ){
  Polygon cHull = new Polygon();
  
  if(points.size()==3){
    cHull.p.add(points.get(0));
    cHull.p.add(points.get(1));
    cHull.p.add(points.get(2));
    return cHull;
  }else if(points.size() <=2) return cHull;
 //we need at least 3 points to make a polygon
 
   for(int i = 0; i< points.size(); i++){
    //this is to make it easier keeping track of what point we're dealing with
    points.get(i).index = i; 
   }
 
  //find lowest point 
  Point lowestPoint = lowestPoint(points);

  cHull.p.add(lowestPoint);

  Point highestPoint = highestPoint(points);
  
  //make a base edge
  Edge baseEdge = new Edge(lowestPoint, new Point(lowestPoint.p.x + 5, lowestPoint.p.y));
  
  
  //start with a random edge to compare to
  Edge possibleEdge = new Edge(new Point(0,0), new Point(0,0));
  boolean checkingLowest = true;
  Point nextPoint = new Point(0,0);

    if( (lowestPoint.index != 0) ){
     possibleEdge  = new Edge(lowestPoint, points.get(0));
      nextPoint = points.get(0);
    }
    else {
       possibleEdge = new Edge(lowestPoint, points.get(1));
       nextPoint = points.get(1);
    }
 
  Point currentP = lowestPoint;
  
  //have an angle to compare to
  float smallestAngle = findAngle(baseEdge, possibleEdge);
  boolean done = false;
  
  while(!done){
    for(int i = 0; i < points.size() ; i++){
      
      //find smallest angle with respect to the current point
      if( currentP.index != i ){
        
        Edge currentEdge = new Edge(currentP, points.get(i));
        float comparisonAngle = findAngle(baseEdge, currentEdge);
        
        if(comparisonAngle < smallestAngle){
         smallestAngle = comparisonAngle; 
         possibleEdge = currentEdge;
         nextPoint = points.get(i);
         
        }
      }
      
    }
    
    smallestAngle = 360;
    currentP = nextPoint;
    cHull.p.add(nextPoint);
    
    //checking for points on the right half
    if((nextPoint.index != highestPoint.index) && checkingLowest){
      baseEdge.p0 = nextPoint;
      baseEdge.p1 = new Point(nextPoint.p.x + 5, nextPoint.p.y);
    }
    else{
      baseEdge.p0 = nextPoint;
      baseEdge.p1 = new Point(nextPoint.p.x - 5, nextPoint.p.y);
      checkingLowest = false;
    }
    //went back to the starting point so it's done
    if(nextPoint.index == lowestPoint.index)
      done = true;
  }
      
  return cHull;
}

Point lowestPoint(ArrayList<Point> points){

    Point lowest = points.get(0);
     
     for(int i = 1; i < points.size(); i++){
       if(points.get(i).p.y < lowest.p.y){
         lowest = points.get(i);
       }
     }
     return lowest;
 
}

Point highestPoint(ArrayList<Point> points){
   
  Point highest = points.get(0);
     
     for(int i = 1; i < points.size(); i++){
       if(points.get(i).p.y > highest.p.y){
         highest = points.get(i);
       }
     }
     return highest;

}

float findAngle(Edge e1, Edge e2){
  PVector p1 = new PVector();
  PVector p2 = new PVector();
  p2.x = e2.p1.p.x - e2.p0.p.x;
  p2.y = e2.p1.p.y - e2.p0.p.y;
  p1.x = e1.p1.p.x - e1.p0.p.x;
  p1.y = e1.p1.p.y - e1.p0.p.y;

  float angle = arcTan2(p1, p2);
  return angle;
}

float arcTan2(PVector sideA, PVector sideB){

    float sideAx= sideA.x ;
    float sideAy= sideA.y ;
    
    float sideBx= sideB.x;
    float sideBy= sideB.y;
    
    float result = (atan2(sideBy, sideBx) - atan2(sideAy,sideAx)) * (180/3.14) ;
    
    if(result < 0) 
    {  
      result =  (360+result) ;
    }

    return result;
   }
