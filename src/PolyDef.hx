import luxe.Vector;

class PolyDef {
    public var sides = 0;
    public var r = 0.0;
    public var pos = new Vector();

    public function new(sides:Int, r:Float, posX:Float, posY:Float) {
        this.sides = sides;
        this.r = r;
        this.pos.x = posX;
        this.pos.y = posY;
    }
}