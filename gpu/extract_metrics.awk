#!/usr/bin/awk -f

# Authors: Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

# Legal Stuff:
#	This script is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, version 3.

#	This script is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#	GNU General Public License for more details.

#	You should have received a copy of the GNU General Public License
#	along with this script. If not, see <http://www.gnu.org/licenses/>.

BEGIN{
	OFS = ","
}
NR == 1 || NR == 6 || NR >= 9 {
	print $0
}
