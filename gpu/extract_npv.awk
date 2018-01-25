#!/usr/bin/awk -f

# Authors: Alfredo Hernández <aldomann.designs@gmail.com>
#          Ruth Kristianingsih <ruth.kristianingsih@mathmods.eu>

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
NR >= 15 && NR <=20 {
	print $1, $2, $3, $4, $5, $6, $7 $8 $9
}
