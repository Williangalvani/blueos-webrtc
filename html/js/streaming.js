server = "http://" + window.location.hostname + ":8088/janus";

var janus = null;
var streaming = [];
var opaqueId = "streamingtest-" + Janus.randomString(12);

var started = false;
var bitrateTimer = null;

function removeClass(el, className) {
    if (el.classList)
        el.classList.remove(className);
    else
        el.className = el.className.replace(new RegExp('(^|\\b)' + className.split(' ').join('|') + '(\\b|$)', 'gi'), ' ');
}

function addClass(el, className) {
    if (el.classList)
        el.classList.add(className);
    else
        el.className += ' ' + className;
}

function setupStreams() {
    // Initialize the library (all console debuggers enabled)
    Janus.init({
        debug: false,
        callback: function () {
            // Make sure the browser supports WebRTC
            if (!Janus.isWebrtcSupported()) {
                alert("No WebRTC support... ");
                return;
            }
            // Create session
            janus = new Janus(
                {
                    server: server,
                    success: function () {
                        for (i = 0; i < 1; i++) {
                            (function (i) { //start wrapper code
                                // Attach to streaming plugin
                                janus.attach(
                                    {
                                        plugin: "janus.plugin.streaming",
                                        opaqueId: opaqueId + i,
                                        success: function (pluginHandle) {
                                            streaming.push(pluginHandle);
                                            setTimeout(startStream, 500);
                                        },
                                        error: function (error) {
                                            alert("Error attaching plugin... " + error);
                                        },
                                        onmessage: function (msg, jsep) {
                                            var result = msg["result"];
                                            if (result !== null && result !== undefined) {
                                                if (result["status"] !== undefined && result["status"] !== null) {
                                                    var status = result["status"];
                                                    if (status === 'starting') {
                                                    }
                                                    else if (status === 'stopped')
                                                        stopStream();
                                                }
                                            } else if (msg["error"] !== undefined && msg["error"] !== null) {
                                                alert(msg["error"]);
                                                stopStream();
                                                return;
                                            }
                                            if (jsep !== undefined && jsep !== null) {
                                                Janus.debug("Handling SDP as well...");
                                                Janus.debug(jsep);
                                                // Answer
                                                streaming[i].createAnswer(
                                                    {
                                                        jsep: jsep,
                                                        media: { audioSend: false, videoSend: false },	// We want recvonly audio/video
                                                        success: function (jsep) {
                                                            Janus.debug("Got SDP!");
                                                            Janus.debug(jsep);
                                                            var body = { "request": "start" };
                                                            streaming[i].send({ "message": body, "jsep": jsep });
                                                            //document.getElementById('watch').html("Stop").removeAttr('disabled').click(stopStream);
                                                        },
                                                        error: function (error) {
                                                            Janus.error("WebRTC error:", error);
                                                            alert("WebRTC error... " + JSON.stringify(error));
                                                        }
                                                    });
                                            }
                                        },
                                        onremotestream: function (stream) {
                                            streaming[i].stream = stream;
                                            //console.log(document.getElementById('remotevideo'+i).length);
                                            if (document.getElementById('remotevideo' + i) == null) {

                                                document.getElementById('stream').innerHTML += '<video class="small" id="remotevideo' + i + '" playsinline autoplay/>';
                                            }
                                            // Show the stream when we get a playing event
                                            document.getElementById("remotevideo" + i).addEventListener("playing", function () {
                                                if (this.videoWidth)
                                                    document.getElementById('remotevideo' + i).style.display = '';
                                            });
                                            Janus.attachMediaStream(document.getElementById('remotevideo' + i), stream);
                                            var videoTracks = stream.getVideoTracks();
                                            if (videoTracks === null || videoTracks === undefined || videoTracks.length === 0 || videoTracks[0].muted) {
                                                // No remote video
                                                document.getElementById('remotevideo' + i).style.display = 'none';
                                            }
                                        },
                                        oncleanup: function () {
                                        }
                                    });
                            })(i);
                        }
                    },
                    error: function (error) {
                        Janus.error(error);
                        alert("Janus error: " + error);
                    },
                    destroyed: function () {
                        window.location.reload();
                    }
                });

        }
    });
}

function startStream() {
    var body = { "request": "watch", id: 10 };
    streaming[0].send({ "message": body });
}

function stopStream(i) {
    streaming[0].send({ "message": body });
    streaming[0].hangup();
}

window.onload = setupStreams;