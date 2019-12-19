import numpy as np
import matplotlib.pyplot as plt
from q1 import *
import copy

def get_distinct_polygons(points) :
	mean_point = np.mean(points)
	shifted_points = points - mean_point
	polygon= sorted(shifted_points, key=lambda a: (np.arctan2(a[1], a[0]), a[0]**2+a[1]**2))
	polygon = polygon + mean_point
	return polygon

def check_in_polygon(point, polygonSet) :
	x = point[0]
	y = point[1]
	oddNodes = False
	for polygon in polygonSet :
		i = 0
		j = len(polygon) - 1
		oddNodes = False 
		for i in range(len(polygon)) :
			#print (oddNodes)
			if (polygon[i][0] == x and polygon[i][1] == y) or (polygon[j][0] == x and polygon[j][1] == y):
				oddNodes = False
				break
			if (((polygon[i][1] < y and polygon[j][1] >= y) or (polygon[j][1] < y and polygon[i][1] >= y)) and 
				(polygon[i][0] <= x or polygon[j][0] <= x)) :
				oddNodes ^= (polygon[i][0]+(y-polygon[i][1])/(polygon[j][1]-polygon[i][1])*(polygon[j][0]-polygon[i][0])<x);
			j = i

		if oddNodes == True :
			break

	return oddNodes

def isOnSegment(pt1, pt2, pt3) :
	dist1 = np.sqrt(np.sum((np.square(pt1[0] - pt3[0]) + np.square(pt1[1] - pt3[1]))))
	dist2 = np.sqrt(np.sum((np.square(pt2[0] - pt3[0]) + np.square(pt2[1] - pt3[1]))))
	dist3 = np.sqrt(np.sum((np.square(pt1[0] - pt2[0]) + np.square(pt1[1] - pt2[1]))))

	diff = abs(dist1 + dist2 - dist3)
	if diff == 0 :
		if np.array_equal(pt2, pt3) or np.array_equal(pt1, pt3) :
			val = 2 
		else :
			val =  1
	else :
		val = 0
	return val

def areSegmentIntersecting(seg1, seg2) :
	p1 = seg1[0]
	q1 = seg1[1]

	p2 = seg2[0]
	q2 = seg2[1]
	or1 = orientation(p1, q1, p2)
	or2 = orientation(p1, q1, q2)
	or3 = orientation(p2, q2, p1)
	or4 = orientation(p2, q2, q1)

	if or1 != or2 and or3 != or4 and or1 != 0 and or2 != 0 and or3 != 0 and or4 != 0:
		return True

	term1 = isOnSegment(p1, q1, p2)
	term2 = isOnSegment(p1, q1, q2)

	if term1 == 0 and term2 == 0:
		return False
	elif term1 == 0 and term2 == 2:
		return False
	elif term1 == 2 and term2 == 0:
		return False
	elif term1 == 2 and term2 == 2 :
		return False
	else :
		return True

def getInternalEdgeList(polygonSet) :
	internalEdgeList = []
	for polygon in polygonSet :
		for vertex1 in polygon :
			for vertex2 in polygon :
				if np.array_equal(vertex1, vertex2) == False :
					seg = np.array([vertex1, vertex2])
					internalEdgeList.append(seg)
	return internalEdgeList

def create_graph(polygonSet, allVertices) :
	adjacency_list = dict([])
	internalEdgeList = getInternalEdgeList(polygonSet)
	for vertex in allVertices :
		adjacency_list[tuple(vertex)] = []
	for vertex1 in allVertices :
		for vertex2 in allVertices :
			edgeFlag = 1
			areVertexSame = np.array_equal(vertex1, vertex2)
			#print (vertex1, vertex2)
			if areVertexSame == False and check_in_polygon(vertex1, polygonSet) == False and check_in_polygon(vertex2, polygonSet) == False and vertex2[0] >= vertex1[0] :
				seg1 = np.array([vertex1, vertex2])
				for seg in internalEdgeList :
					isIntersect = areSegmentIntersecting(seg, seg1)
					if isIntersect == True :
						edgeFlag = 0
					if edgeFlag == 0 :
						break
				if edgeFlag == 1 :
					weight = (vertex1[0] - vertex2[0])**2 + (vertex1[1] - vertex2[1])**2
					listVal = [vertex2, weight]
					adjacency_list[tuple(vertex1)].append(listVal)
	return adjacency_list

def djikstra_path(adjacency_list, allVertices, startPoint, endPoint) :
	output_dict = dict([])
	path_array = []
	for vertex in allVertices :
		output_dict[tuple(vertex)] = []

	for keys, values in adjacency_list.items() :
		if np.array_equal(np.array(keys), startPoint) :
			output_dict[keys] = [0, False]
			current_vertex = keys
		else :
			output_dict[keys] = [float('inf'), False]

	while True :
		path_array.append(current_vertex)
		if np.array_equal(current_vertex, endPoint) :
			break

		for values in adjacency_list[current_vertex] :
			nextNode = values[0]
			#print (output_dict[tuple(nextNode)], nextNode)
			#print (current_vertex, nextNode, output_dict[tuple(nextNode)][0], values[1])
			if (output_dict[tuple(nextNode)][1] == False) :
				current_dist_nextNode = output_dict[tuple(nextNode)][0]
				new_dist_nextNode = output_dict[current_vertex][0] + values[1]
				if new_dist_nextNode < current_dist_nextNode :
					output_dict[tuple(nextNode)][0] = new_dist_nextNode
			#print (output_dict[tuple(nextNode)][0])
			if np.array_equal(nextNode, endPoint) :
				path_array.append(nextNode)
				return path_array
		output_dict[current_vertex][1] = True
		#print ("dist", output_dict[tuple(nextNode)][0], nextNode)
		minWeight = float('inf')
		#print (current_vertex)
		for values in adjacency_list[current_vertex] :
			nextNode = tuple(values[0])
			#print (current_vertex, nextNode, output_dict[nextNode][0])
			if (output_dict[tuple(nextNode)][1] == False) :
				weight = output_dict[nextNode][0]
				if weight < minWeight :
					minWeight = weight
					next_vertex = nextNode
					current_vertex = next_vertex
		#print (current_vertex)
	return path_array

if __name__ == "__main__" :
	numPolygon = 3
	numPoints = 4 
	rangeMax = 50
	polygonSet = []
	for i in range(numPolygon) :
		points = np.random.rand(numPoints, 2)*rangeMax
		mean_points = np.mean(points) + (i+1)*rangeMax
		polyPoints = convexHull(points)
		#print (points)
		#print (polyPoints)
		plt.plot(polyPoints[:,0], polyPoints[:,1], 'r')
		polyPoints = polyPoints[:-1]
		polygon = get_distinct_polygons(polyPoints)
		polygonSet.append(polygon)

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
