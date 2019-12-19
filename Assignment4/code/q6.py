import numpy as np
from scipy.ndimage.morphology import distance_transform_edt
from matplotlib import pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from scipy.interpolate import RectBivariateSpline

waypoints = 300
N = 101
OBST = np.array([[20, 30], [60, 40], [70, 85]])
epsilon = np.array([[25], [20], [30]])

obs_cost = np.zeros((N, N))
for i in range(OBST.shape[0]):
    t = np.ones((N, N))
    t[OBST[i, 0], OBST[i, 1]] = 0
    t_cost = distance_transform_edt(t)
    t_cost[t_cost > epsilon[i]] = epsilon[i]
    t_cost = 1 / (2 * epsilon[i]) * (t_cost - epsilon[i])**2
    obs_cost = obs_cost + t_cost

gx, gy = np.gradient(obs_cost)

SX = 10
SY = 10
GX = 90
GY = 90

traj = np.zeros((2, waypoints))
traj[0, 0] = SX
traj[1, 0] = SY
dist_x = GX-SX
dist_y = GY-SY
for i in range(1, waypoints):
    traj[0, i] = traj[0, i-1] + dist_x/(waypoints-1)
    traj[1, i] = traj[1, i-1] + dist_y/(waypoints-1)

path_init = traj.T
tt = path_init.shape[0]
path_init_values = np.zeros((tt, 1))
for i in range(tt):
    path_init_values[i] = obs_cost[int(np.floor(path_init[i, 0])), int(np.floor(path_init[i, 1]))]

gxSpline = RectBivariateSpline(np.arange(gx.shape[0]), np.arange(gx.shape[1]), gx)
gySpline = RectBivariateSpline(np.arange(gy.shape[0]), np.arange(gy.shape[1]), gy)
for i in range(5000) :
	# Code for Part a
	'''
	for j in range(1,tt-1) :
		point = (path_init[j,0], path_init[j,1])
		updateX = 0.1*gxSpline.ev(point[0], point[1])
		updateY = 0.1*gySpline.ev(point[0], point[1])
		path_init[j, 0] = path_init[j, 0] - 0.1 * updateX
		path_init[j, 1] = path_init[j, 1] - 0.1 * updateY
	# Code for Part b
	'''
	'''
	for j in range(1,tt-1) :
		point = (path_init[j,0], path_init[j,1])
		updateX = gxSpline.ev(point[0], point[1])
		updateY = gySpline.ev(point[0], point[1])
		pointEpsilonX = (path_init[j,0] - path_init[j-1,0])
		pointEpsilonY = (path_init[j,1] - path_init[j-1,1])
		totalUpdateX = 0.8*updateX + 4*pointEpsilonX
		totalUpdateY = 0.8*updateY + 4*pointEpsilonY
		#print (totalUpdateX, totalUpdateY)
		path_init[j, 0] = path_init[j, 0] - 0.1 * totalUpdateX
		path_init[j, 1] = path_init[j, 1] - 0.1 * totalUpdateY
	'''
	# Code for part C

	for j in range(1,tt-1) :
		point = (path_init[j,0], path_init[j,1])
		updateX = gxSpline.ev(point[0], point[1])
		updateY = gySpline.ev(point[0], point[1])
		pointEpsilonX = (2 * path_init[j,0] - path_init[j-1,0] - path_init[j+1,0])
		pointEpsilonY = (2 * path_init[j,1] - path_init[j-1,1] - path_init[j+1,1])
		totalUpdateX = 0.8*updateX + 4*pointEpsilonX
		totalUpdateY = 0.8*updateY + 4*pointEpsilonY
		#print (totalUpdateX, totalUpdateY)
		path_init[j, 0] = path_init[j, 0] - 0.1 * totalUpdateX
		path_init[j, 1] = path_init[j, 1] - 0.1 * totalUpdateY

#print (path_init)
# Plot 2D
plt.imshow(obs_cost.T)
plt.plot(path_init[:, 0], path_init[:, 1], 'ro')

# Plot 3D
fig3d = plt.figure()
ax3d = fig3d.add_subplot(111, projection='3d')
xx, yy = np.meshgrid(range(N), range(N))
ax3d.plot_surface(xx, yy, obs_cost, cmap=plt.get_cmap('coolwarm'))
ax3d.scatter(path_init[:, 0], path_init[:, 1], path_init_values, s=20, c='r')

plt.show()

path = path_init