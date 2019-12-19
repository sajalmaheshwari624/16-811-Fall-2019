import numpy as np
import matplotlib.pyplot as plt

def convexHull(points) :
	pointsX = points[:,0]
	pointsY = points[:,1]


	pIndex = np.argmin(pointsX)
	p = np.array([pointsX[pIndex], pointsY[pIndex]])
	pIndexFirst = pIndex
	i = 0
	convexOut = np.array([])
	while 1 :
		#print (pIndex)
		if i == 0 :
			convexOut = p
		else :
			convexOut = np.append(convexOut, points[pIndex,:], axis = 0)
		qIndex = (pIndex + 1) % (pointsX.size)
		for index in range(pointsX.size) :
			direction = orientation(points[pIndex,:], points[index, :], points[qIndex,:])
			if direction == 2 :
				qIndex = index
		pIndex = qIndex
		if pIndex == pIndexFirst :
			break
		i += 1
	convexOut = np.append(convexOut, points[pIndex,:], axis = 0)
	convexOut = np.reshape(convexOut, (convexOut.size // 2, 2))
	return convexOut



def orientation(p,q,r) :
	val = (q[1] - p[1]) * (r[0] - q[0]) - (q[0] - p[0]) * (r[1] - q[1])
	if val == 0 :
		return 0
	if val > 0 :
		return 1
	if val < 0 :
		return 2


if __name__ == "__main__" :
	numPoints = 25
	rangeMax = 100
	numTest = 4
	for i in range(numTest) :
		points = np.random.rand(numPoints, 2)*rangeMax
		plt.scatter(points[:,0], points[:,1])
		hullPoints = convexHull(points)
		plt.plot(hullPoints[:,0], hullPoints[:,1], 'r')
		#print (hullPoints)
		plt.show()