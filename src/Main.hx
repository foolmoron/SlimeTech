import luxe.Input;
import luxe.Sprite;
import luxe.Color;
import luxe.States;
import luxe.Vector;
import luxe.Ev;
import luxe.Log.*;
import luxe.IO;
import luxe.utils.Random;
import luxe.utils.Maths;
import luxe.tween.easing.*;
import luxe.components.physics.nape.*;
import nape.phys.*;
import nape.shape.*;
import entities.*;
import components.*;
import states.*;

class Main extends luxe.Game {

    public static var rand = new Random(0x3389345);
    public static var state : States;

    public static var squareSize = 640;
    public static var squareOffset = new Vec(0, -26);
    public static var gridSize = 32;

    public static var grid = new Array<Array<Float>>();
    public static var gridCalcFrame = true;

    public static var LEVELS = new Array<Level>();
    public static var solvedLevel = 0;

    override function config(config:luxe.AppConfig) {
        config.preload.jsons.push({ id:'assets/levels.json' });
        config.preload.textures.push({ id:'assets/textures/circle.png' });
        config.preload.textures.push({ id:'assets/textures/blob.png' });
        config.preload.textures.push({ id:'assets/textures/blobback.png' });
        config.preload.textures.push({ id:'assets/textures/bgthing.png' });
        config.preload.textures.push({ id:'assets/textures/fg.png' });
        config.preload.textures.push({ id:'assets/textures/button.png' });
        config.preload.textures.push({ id:'assets/textures/buttondown.png' });
        config.preload.textures.push({ id:'assets/textures/buttondisabled.png' });
        config.preload.textures.push({ id:'assets/textures/swirl.png' });
        return config;
    }

    override function ready() {
        log('READY');
        untyped document.body.style.backgroundColor = "#efefef";
        new FPS();

        var l = Std.parseInt(app.io.string_load('solved'));
        if (l != null) {
            solvedLevel = l;
        }
        solvedLevel = 0;

        // physics
        Luxe.physics.nape.gravity = new Vec(0, 0);

        var json = Luxe.resources.json('assets/levels.json');
        var items : Array<Dynamic> = json.asset.json;
        for (item in items) {
            var level = new Level();
            level.sourcePos.x = item.sourcePos[0];
            level.sourcePos.y = item.sourcePos[1];
            level.sourceVel.x = item.sourceVel[0];
            level.sourceVel.y = item.sourceVel[1];
            var polys : Array<Dynamic> = item.polys;
            for (poly in polys) {
                level.polys.push(new PolyDef(poly.sides, poly.pos[0], poly.pos[1]));
            }
            LEVELS.push(level);
        }

        // border physics
        var border = new Body(BodyType.STATIC);
        border.shapes.add(new Polygon(Polygon.rect(0, 54, Luxe.screen.w, -200)));
        border.shapes.add(new Polygon(Polygon.rect(0, Luxe.screen.h - 106, Luxe.screen.w, 200)));
        border.shapes.add(new Polygon(Polygon.rect(30, 0, -200, Luxe.screen.h)));
        border.shapes.add(new Polygon(Polygon.rect(Luxe.screen.w - 30, 0, 200, Luxe.screen.h)));
        border.space = Luxe.physics.nape.space;

        // stuff
        var gridsquare = new Sprite({
            name: 'gridsquare',
            color: new Color().rgb(0xe9e9e9),
            pos: Luxe.screen.mid + squareOffset,
            size: new Vec(squareSize, squareSize),
            depth: -100,
        });
        var bgthing = new Sprite({
            name: 'bgthing',
            texture: tex('bgthing'),
            pos: Luxe.screen.mid,
            size: Luxe.screen.size,
            depth: -90,
        });
        var fg = new Sprite({
            name: 'fg',
            texture: tex('fg'),
            pos: Luxe.screen.mid,
            size: Luxe.screen.size,
            depth: 100,
        });

        // grid lines
        var xgrid = Math.floor(Luxe.screen.size.x / gridSize);
        var ygrid = Math.floor(Luxe.screen.size.y / gridSize);
        for (x in 1 ... xgrid-1) {
            Luxe.draw.line({
                p0: new Vec(x * gridSize + 30, 54),
                p1: new Vec(x * gridSize + 30, Luxe.screen.size.y),
                color: new Color().rgb(0xb8b8b8),
                depth: -95,
            });
        }
        for (y in 1 ... ygrid-1) {
            Luxe.draw.line({
                p0: new Vec(30, y * gridSize + 54),
                p1: new Vec(Luxe.screen.size.x, y * gridSize + 54),
                color: new Color().rgb(0xb8b8b8),
                depth: -95,
            });
        }

        // grid setup
        for (x in 0 ... xgrid) {
            grid.push(new Array<Float>());
            for (y in 0 ... ygrid) {
                grid[x].push(0);
            }
        }

        // states
        state = new States({ name: 'game' });

        state.add(new TitleState({name: 'title'}));
        for (i in 0 ... LEVELS.length) {
            state.add(new GameState({name: 'game' + (i + 1)}, i + 1, LEVELS[i]));            
        }
        Luxe.on(Ev.init, function(_) {
            state.set('title');
        });
    }

    override function onkeyup(e:KeyEvent) {
        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }
    }

    override function update(dt:Float) {
        if (gridCalcFrame) {
            for (x in 0 ... grid.length) {
                for (y in 0 ... grid[x].length) {
                    grid[x][y] = 0;
                }
            }            
        }
        gridCalcFrame = !gridCalcFrame;

        FillPoly.IsFillFrame = !FillPoly.IsFillFrame;
        app.io.string_save('solved', ''+solvedLevel);
    }

    public static function tex(id:String) {
        return Luxe.resources.texture('assets/textures/' + id + '.png');
    }
}