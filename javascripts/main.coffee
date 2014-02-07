HEIGHT = window.innerHeight
WIDTH = window.innerWidth
console.log WIDTH, HEIGHT

renderer = new THREE.WebGLRenderer( alpha: true )
#renderer.setClearColor( 0x000000, 0)
renderer.setClearColor( 0x000000, 1)
renderer.setSize(WIDTH, HEIGHT)
document.getElementById('threejs').appendChild(renderer.domElement)


camera = new THREE.PerspectiveCamera(
  90, # make leap-dependent?
  WIDTH / HEIGHT,
  10,
  1000
)


camera.position.z = 40
camera.position.x = 10
camera.position.y = 10
camera.lookAt(new THREE.Vector3(0,0,0))

scene = new THREE.Scene()
scene.add(camera)

scene.add new THREE.AxisHelper(50)


scene.add new THREE.AmbientLight( 0x222222)

pointLight = new THREE.PointLight(0xFFffff)
pointLight.position =  new THREE.Vector3(20,20,10)
pointLight.lookAt new THREE.Vector3(0,0,10)
scene.add(pointLight)

rectangle = new THREE.Mesh(
  new THREE.CubeGeometry(
    4, 1, 8),
  new THREE.MeshPhongMaterial({
      color: 0x00ff00
    })
  )
rectangle.position = new THREE.Vector3(0,0,10)
scene.add(rectangle)


sphere = new THREE.Mesh(
  new THREE.SphereGeometry(1),
  new THREE.MeshPhongMaterial({
      color: 0xff0000
    })
)
sphere.position = new THREE.Vector3(10,10,0)
scene.add(sphere)

loader = new THREE.JSONLoader()
animation = undefined
handMesh = undefined

handRoll = 0

# load the model and create everything
loader.load 'javascripts/right-hand-isaac.json',  (geometry, materials) ->
  THREE.GeometryUtils.center(geometry)
  handMesh = new THREE.SkinnedMesh( geometry, new THREE.MeshFaceMaterial(materials))
  scene.add handMesh

#  handMesh.quaternion.setFromAxisAngle(
#    new THREE.Vector3( sphere.position.x, sphere.position.y, sphere.position.z ).normalize()
#  , (Math.PI / 2) * 2
#  )
#  p = new THREE.Vector3( sphere.position.x, sphere.position.y, sphere.position.z ).normalize()
#  handMesh.quaternion = new THREE.Quaternion(p.x, p.y, p.z, 1).normalize()
#  rectangle.lookAt(sphere.position)
#  renderer.render(scene, camera)
  Leap.loop (frame)->
    if leapHand = frame.hands[0]
      rectangle.position.x = leapHand.stabilizedPalmPosition[0] / 10
      rectangle.position.y = leapHand.stabilizedPalmPosition[1] / 10
      rectangle.position.z = leapHand.stabilizedPalmPosition[2] / 10
#      sphere.position.x = leapHand.direction[0] * 10
      handRoll = leapHand.roll()

      rectangle.rotation = new THREE.Euler(
        leapHand.direction[1], #,
        -leapHand.direction[0],
        handRoll
        'XYZ'
      )
    renderer.render(scene, camera)
