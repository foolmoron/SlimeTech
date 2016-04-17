import luxe.Vector;

class PolyDef {
    public var sides = 0;
    public var pos = new Vector();

    public function new(sides:Int, posX:Float, posY:Float) {
        this.sides = sides;
        this.pos.x = posX;
        this.pos.y = posY;
    }
}