import numpy as np
import matplotlib.pyplot as plt 
from q1 import *
from q2 import *
import copy

if __name__ == "__main__" :
	numPolygon = 3
	numPoints = 4 
	rangeMax = 50
	polygonSet = []

	robot_poly = np.array([[1,1], [1,2], [2,2]])
	xMin = np.min(robot_poly[:,0])
	robot_poly[:,0] -= xMin
	yMin = np.min(robot_poly[:,1])
	robot_poly[:,1] -= yMin

	for i in range(numPolygon) :
		points = np.random.rand(numPoints, 2)*rangeMax
		points_new = points
		for j in range(robot_poly.shape[0]) :
			points_add = points - robot_poly[j,:]
			points_new = np.vstack((points_new, points_add))
		polyPoints_new = convexHull(points_new)
		polyPoints = convexHull(points)
		plt.plot(polyPoints[:,0], polyPoints[:,1], 'r')
		plt.plot(polyPoints_new[:,0], polyPoints_new[:,1], 'g')
		polyPoints_new = polyPoints_new[:-1]
		polygon_new = get_distinct_polygons(polyPoints_new)
		polygonSet.append(polygon_new)

	startPoint = np.array([30,30])
	endPoint = np.array([50, 50])
	if check_in_polygon(startPoint, polygonSet) == True :
		print ("No path possible!")
		plt.scatter(startPoint[0], startPoint[1])
		plt.scatter(endPoint[0], endPoint[1])
		plt.show()
	elif check_in_polygon(endPoint, polygonSet) == True :
		print ("No path possible!")
		plt.scatter(startPoint[0], startPoint[1])
		plt.scatter(endPoint[0], endPoint[1])
		plt.show()
	else :
		allVertices = [startPoint]
		count = 0
		for polygons in polygonSet :
			count += 1
			allVertices = np.vstack((allVertices, polygons))
		allVertices = np.vstack((allVertices, [endPoint]))
		adjacency_list = (create_graph(polygonSet, allVertices))
		#print (adjacency_list)
		path = np.array(djikstra_path(adjacency_list, allVertices, startPoint, endPoint))
		plt.plot(path[:,0], path[:,1])
		plt.show()