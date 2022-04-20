
$( function() {
    $(".droppable").attr("data-contains","");
    function reverter(t){
        target = $(t).attr("data-target");
        $(t).position({
            my: "left top",
            at: "left top",
            of: target,
            using: function(pos) {
              $(this).animate(pos, "fast", "linear");
            }
        });
        return false;
    }
    function checkContinue(){
        if (!$(".item:not(.dropped)").length){
            $('.whenFinished').show();
        }
    }
    function post_audio(target, action){
        var to_post = { "submitlist":target };
        to_post[target] = action;
        to_post["id"] = $("body").data("id");
        to_post["page"] = $("body").data("page");
        $.post("../api/audio.cfm",to_post);        
    }
    function post_results(a, p){
        console.log(a);
        console.log(p);
        var to_post = { "submitlist":a };
        to_post[a] = p;
        to_post["id"] = $("body").data("id");
        to_post["page"] = $("body").data("page");
        $.post("../api/post.cfm",to_post);        
    }
    $(".finished").click(function(){
        $(".whenDone").show();
        $(this).prop("disabled",true);
    });
    $( ".draggable" ).draggable({
        opacity: .4
        ,stack: ".item"
        ,cursor: "move"
        ,snap: ".droppable"
        ,snapMode: "inner"
        ,start: function( event, ui ) { }
        ,revert: function(event, ui){ reverter(this); }          
    });
    $( ".droppable" ).droppable({
            accept: ".item",
            greedy: true,
            out: function(event, ui) {
                t = ui.draggable[0].id;
                c = $(this).attr("data-contains");
                if (c == t){
                    $(ui.draggable).draggable({ revert: reverter(this) });
                    $(ui.draggable).removeClass("dropped");
                    $(this).removeClass("highlight");
                    $(this).find("input").val("");
                    $(this).attr("data-contains","");
                    checkContinue();
                }
            },
            drop: function(event, ui) {
                t = ui.draggable[0].id;
                var $this = $(this);
                if ($(this).hasClass("highlight") && $(this).data("contains") != t){
                    container = $(this).find("input").attr("name");
                    target = $('#' + t);
                    $('#' + t).addClass("dropped");
                    $('#' + t).draggable("option","revert",function(event, ui){ reverter(target); });
                    post_results(t, "-1");
                    checkContinue();
                } else {
                    $('#' + t).draggable("option","revert", false);
                    $('#' + t).addClass("dropped");
                    $('*[data-contains="' + t + '"').removeClass("highlight").data("contains","").find("input").val("");
                    $(this).find("input").val(t);
                    $(this).attr("data-contains",t);
                    $(this).addClass("highlight");
                    container = $(this).find("input").attr("name");
                    post_results(t, container);
                    ui.draggable.position({
                        my: "center",
                        at: "center",
                        of: $this,
                        using: function(pos) {
                            $(this).animate(pos, "fast", "linear");
                        }
                    });                    
                    checkContinue();
                }
            }
          });            
    $( "#item-container" ).droppable({
            accept: ".item",
            drop: function(event, ui){
                t = ui.draggable[0].id;
                target = $("#" + t).attr("data-target");
                post_results(t, "");
                ui.draggable.position({
                    my: "left top",
                    at: "left top",
                    of: $(target),
                    using: function(pos) {
                      $(this).animate(pos, "fast", "linear");
                    }
                });
            }
        });     
    $(".item").on('click', "button.play", function(e){
        target = $(this).attr("data-play");
        $(this).removeClass("play");
        $(this).addClass("stop");
        document.getElementById(target).currentTime = 0;
        document.getElementById(target).play()
        post_audio(target, "1");
        e.preventDefault();
        return false;
    });
    $(".item").on('click', "button.stop", function(e){
        target = $(this).attr("data-play");
        $(this).removeClass("stop");
        $(this).addClass("play");
        post_audio(target, "-1");
        document.getElementById(target).pause()
        document.getElementById(target).currentTime = 0;
        e.preventDefault();
        return false;
    });

    $("audio").each(function(){
        id = $(this).attr("id");
        a = document.getElementById(id);
        a.addEventListener('ended', function() {
            target = $(this).attr("data-player");
            $("#" + target).removeClass("stop");
            $("#" + target).addClass("play");
            post_audio(id, "0");
        }, false);
    });

    var count = 60, timer = setInterval(function() {
        count--;
        if(count == 1){
            clearInterval(timer);
            $(".show60").show();
        }
    }, 1000);
}); 
