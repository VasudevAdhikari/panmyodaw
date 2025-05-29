let sales = null;
let pieChartData = null;
function setSales(s) {
	sales = s;
	console.log(sales);
}
function setPieChartData(d) {
	pieChartData = d;
	console.log("pieChartData");
	console.log(pieChartData);
	console.log("sales");
	console.log(sales);
}

document.addEventListener("DOMContentLoaded", () => {
	initializeChart();
	// Initial draw for the pie chart

	// Add event listener for window resize
	window.addEventListener('resize', () => {
		d3.select("#pie-chart").selectAll("*").remove();  // Fix here
		d3.select("#chart").selectAll("*").remove();      // Fix here
		initializeChart();
		drawPieChart();
	});

});

function initializeChart() {
	const chartType = document.getElementById("chart-type");
	if (!chartType) return;

	const value = chartType.value;

	// Clear previous chart
	const chartContainer = document.getElementById('chart');
	if (chartContainer) {
		chartContainer.innerHTML = '';
	}

	if (value === "line") {
		drawLineChart();
	} else if (value === "bar") {
		drawBarChart(sales);
	}
}

function getChartDimensions() {
	const width = 0.90 * window.innerWidth;
	const chartHeight = width > 1000 ? 0.55 * window.innerHeight : 0.35 * window.innerHeight;
	const pieChartHeight = width > 1000 ? 0.45 * window.innerHeight : 0.25 * window.innerHeight;
	return {
		chartWidth: (width > 1000 ? 0.4 * window.innerWidth : 0.8 * window.innerWidth),
		chartHeight,
		pieChartHeight
	};
}

function drawLineChart() {
	const data = [
		{ date: null, value: null },
		{ date: null, value: null },
		{ date: null, value: null },
		{ date: null, value: null },
		{ date: null, value: null },
		{ date: null, value: null },
		{ date: null, value: null }
	];
	console.log(sales);

	function getPreviousMonthsDates(startDate, count = 7) {
		let dates = [];
		let currentDate = new Date(startDate);

		for (let i = 0; i < count; i++) {
			dates.push(new Date(currentDate)); // Push the current date to the array
			currentDate.setMonth(currentDate.getMonth() - 1); // Go to the previous month
		}
		dates.reverse();
		return dates;
	}

	const given_date = new Date(sales[6][0] + "-01");
	const saleMonths = getPreviousMonthsDates(given_date);

	sales.forEach((sale, i) => {
		const totalSales = parseInt(sale[1], 10);

		console.log(saleMonths[i]);
		console.log(totalSales);

		data[i].date = saleMonths[i];
		data[i].value = totalSales;
	});


	const container = document.getElementById('chart');
	if (!container) return;
	const { chartWidth, chartHeight } = getChartDimensions();
	const width = chartWidth;
	const height = chartHeight;
	const margin = { top: 20, right: 20, bottom: 50, left: 100 };

	const svg = d3.select("#chart")
		.append("svg")
		.attr("width", width)
		.attr("height", height)
		.append("g")
		.attr("transform", `translate(${margin.left},${margin.top})`);

	const x = d3.scaleTime()
		.domain(d3.extent(data, d => d.date))
		.range([0, width - margin.left - margin.right]);

	const y = d3.scaleLinear()
		.domain([0, d3.max(data, d => d.value)])
		.nice()
		.range([height - margin.top - margin.bottom, 0]);

	// Gradient for line
	svg.append("linearGradient")
		.attr("id", "line-gradient")
		.attr("gradientUnits", "userSpaceOnUse")
		.attr("x1", 0).attr("y1", 0)
		.attr("x2", 0).attr("y2", height)
		.selectAll("stop")
		.data([
			{ offset: "0%", color: "purple" },
			{ offset: "100%", color: "lightpurple" }
		])
		.enter().append("stop")
		.attr("offset", d => d.offset)
		.attr("stop-color", d => d.color);

	// Gradient for area
	svg.append("linearGradient")
		.attr("id", "area-gradient")
		.attr("gradientUnits", "userSpaceOnUse")
		.attr("x1", 0).attr("y1", 0)
		.attr("x2", 0).attr("y2", height)
		.selectAll("stop")
		.data([
			{ offset: "0%", color: "#66ffcc", opacity: 1 },
			{ offset: "70%", color: "white", opacity: 0.2 }
		])
		.enter().append("stop")
		.attr("offset", d => d.offset)
		.attr("stop-color", d => d.color)
		.attr("stop-opacity", d => d.opacity);

	const area = d3.area()
		.curve(d3.curveCatmullRom)
		.x(d => x(d.date))
		.y0(height - margin.top - margin.bottom)
		.y1(d => y(d.value));

	svg.append("path")
		.data([data])
		.attr("fill", "url(#area-gradient)")
		.attr("d", area);

	svg.append("path")
		.data([data])
		.attr("fill", "none")
		.attr("stroke", "url(#line-gradient)")
		.attr("stroke-width", 2)
		.attr("d", d3.line()
			.curve(d3.curveCatmullRom)
			.x(d => x(d.date))
			.y(d => y(d.value))
		);

	// Tooltip for line chart
	const tooltip = d3.select("#chart").append("div")
		.attr("class", "tooltip")
		.style("opacity", 0);

	svg.selectAll("dot")
		.data(data)
		.enter().append("circle")
		.attr("r", 5)
		.attr("cx", d => x(d.date))
		.attr("cy", d => y(d.value))
		.on("mouseover", (event, d) => {
			tooltip.transition()
				.duration(200)
				.style("opacity", .9);
			tooltip.html(`Date: ${d.date.toLocaleDateString()}<br/>Value: ${d.value}`)
				.style("left", (event.pageX - 50) + "px")
				.style("top", (event.pageY - 50) + "px");
		})
		.on("mouseout", d => {
			tooltip.transition()
				.duration(500)
				.style("opacity", 0);
		});

	// Add x-axis and y-axis
	svg.append("g")
		.attr("class", "x-axis")
		.attr("transform", `translate(0,${height - margin.top - margin.bottom})`)
		.call(d3.axisBottom(x))
		.append("text")
		.attr("fill", "#000")
		.attr("x", (width - margin.left - margin.right) / 2)
		.attr("y", margin.bottom - 10)
		.attr("text-anchor", "middle")
		.text("Date");

	svg.append("g")
		.attr("class", "y-axis")
		.call(d3.axisLeft(y))
		.append("text")
		.attr("fill", "#000")
		.attr("transform", "rotate(-90)")
		.attr("x", - (height - margin.top - margin.bottom) / 2)
		.attr("y", -margin.left + 15)
		.attr("dy", "0.71em")
		.attr("text-anchor", "middle")
		.text("Value");
}


function drawBarChart() {
		const data = [
		{ category: null, value: null },
		{ category: null, value: null },
		{ category: null, value: null },
		{ category: null, value: null },
		{ category: null, value: null },
		{ category: null, value: null },
		{ category: null, value: null }
	];

	function getPreviousMonthsDates(startDate, count = 7) {
		let dates = [];
		let currentDate = new Date(startDate);

		for (let i = 0; i < count; i++) {
			dates.push(new Date(currentDate)); // Push the current date to the array
			currentDate.setMonth(currentDate.getMonth() - 1); // Go to the previous month
		}

		return dates;
	}
	
	function getMonthYear(date) {
		const monthNames = [
    		"Jan", "Feb", "Mar", "Apr", "May", "Jun",
    		"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
		];
		
		const year = date.getFullYear();
		const month = date.getMonth();
		const monthName = monthNames[month];
		
		return monthName + "\n" + year;
	}
	
	const given_date = new Date(sales[6][0] + "-01");
	const saleMonths = getPreviousMonthsDates(given_date);
	saleMonths.reverse();
	sales.forEach((sale, i) => {
		const totalSales = parseInt(sale[1], 10);

		console.log(saleMonths[i]);
		console.log(totalSales);

		data[i].category = getMonthYear(saleMonths[i]);
		data[i].value = totalSales;
	});

	const container = document.getElementById('chart');
	if (!container) return;

	const { chartWidth, chartHeight } = getChartDimensions();
	const width = chartWidth;
	const height = chartHeight;
	const margin = { top: 20, right: 20, bottom: 30, left: 80 };

	const svg = d3.select("#chart")
		.append("svg")
		.attr("width", width)
		.attr("height", height)
		.append("g")
		.attr("transform", `translate(${margin.left},${margin.top})`);

	const x = d3.scaleBand()
		.domain(data.map(d => d.category))
		.range([0, width - margin.left - margin.right])
		.padding(0.1);

	const y = d3.scaleLinear()
		.domain([0, d3.max(data, d => d.value)])
		.nice()
		.range([height - margin.top - margin.bottom, 0]);

	// Horizontal grid lines
	svg.append("g")
		.attr("class", "grid")
		.call(d3.axisLeft(y).ticks(5).tickSize(-width + margin.left + margin.right).tickFormat(""));

	// Gradients for bars
	const gradients = svg.append("defs")
		.selectAll("linearGradient")
		.data(data)
		.enter().append("linearGradient")
		.attr("id", (d, i) => `gradient${i}`)
		.attr("x1", "0%")
		.attr("y1", "0%")
		.attr("x2", "0%")
		.attr("y2", "100%")
		.each(function(d, i) {
			const colors = [
				["#ffffcc", "#ccff99"],
				["#aa66cc", "#cf9bcc"],
				["#ccccff", "#99ccff"],
				["#ffcc99", "#bfcefe"],
				["#cc66ff", "#cc99ff"],
				["#66ff66", "#29fd99"],
				["#aa66cc", "#cf9bcc"]
			];
			const color = i === 0 ? ["#66ffcc", "#66ffcc"] : colors[i % colors.length];
			d3.select(this).selectAll("stop")
				.data([
					{ offset: "0%", color: color[0] },
					{ offset: "100%", color: color[1] }
				])
				.enter().append("stop")
				.attr("offset", d => d.offset)
				.attr("stop-color", d => d.color);
		});

	gradients.append("stop")
		.attr("offset", "0%")
		.attr("stop-color", (d, i) => d3.interpolateBlues(i / data.length));

	gradients.append("stop")
		.attr("offset", "100%")
		.attr("stop-color", (d, i) => d3.interpolateBlues((i + 1) / data.length));

	const tooltip = d3.select("#chart").append("div")
		.attr("class", "tooltip")
		.style("opacity", 0);

	svg.selectAll(".bar")
		.data(data)
		.enter().append("rect")
		.attr("class", "bar")
		.attr("x", d => x(d.category))
		.attr("y", d => y(d.value))
		.attr("width", x.bandwidth())
		.attr("height", d => height - margin.top - margin.bottom - y(d.value))
		.attr("rx", 10) // Rounded corners
		.attr("fill", (d, i) => `url(#gradient${i})`)
		.on("mouseover", function(event, d) {
			d3.select(this).transition()
				.duration(200)
				.attr("transform", "scale(1.02)"); // Zoom effect

			tooltip.transition()
				.duration(200)
				.style("opacity", .9);
			tooltip.html(`Category: ${d.category}<br/>Value: ${d.value}`)
				.style("left", (event.pageX - 50) + "px")
				.style("top", (event.pageY - 50) + "px");
		})
		.on("mouseout", function(d) {
			d3.select(this).transition()
				.duration(500)
				.attr("transform", "scale(1)");

			tooltip.transition()
				.duration(500)
				.style("opacity", 0);
		});

	svg.append("g")
		.attr("class", "x-axis")
		.attr("transform", `translate(0,${height - margin.top - margin.bottom})`)
		.call(d3.axisBottom(x));

	svg.append("g")
		.attr("class", "y-axis")
		.call(d3.axisLeft(y));
}
















function drawPieChart() {
    const total = d3.sum(pieChartData, d => Number(d[1]));  // Calculate the total value

    const data = pieChartData.map((pd) => ({
        category: pd[0],
        value: Number(pd[1])  // Use the actual value for the pie chart
    }));

    const container = document.getElementById('pie-chart');
    if (!container) return;

    const { pieChartHeight } = getChartDimensions();
    const width = pieChartHeight;
    const height = pieChartHeight;
    const radius = Math.min(width, height) / 2;

    const svg = d3.select("#pie-chart")
        .append("svg")
        .attr("width", width + 150)  // Added space for legend
        .attr("height", height)
        .append("g")
        .attr("transform", `translate(${width / 2},${height / 2})`);

    const color = d3.scaleOrdinal(d3.schemeCategory10);

    const pie = d3.pie()
        .value(d => d.value)  // Use the actual values
        .sort(null);  // Ensure that the slices are not sorted

    const arc = d3.arc()
        .outerRadius(radius - 10)
        .innerRadius(0);

    const arcHover = d3.arc()
        .outerRadius(radius - 5)
        .innerRadius(0);

    // Gradients for pie slices
    const gradients = svg.append("defs")
        .selectAll("linearGradient")
        .data(data)
        .enter().append("linearGradient")
        .attr("id", (d, i) => `pie-gradient${i}`)
        .attr("x1", "0%")
        .attr("y1", "0%")
        .attr("x2", "100%")
        .attr("y2", "100%");

    gradients.append("stop")
        .attr("offset", "0%")
        .attr("stop-color", (d, i) => d3.interpolateCool(i / data.length));

    gradients.append("stop")
        .attr("offset", "100%")
        .attr("stop-color", (d, i) => d3.interpolateCool((i + 1) / data.length));

    const tooltip = d3.select("body").append("div")
        .attr("class", "tooltip")
        .style("position", "absolute")
        .style("text-align", "center")
        .style("width", "120px")
        .style("height", "50px")
        .style("padding", "5px")
        .style("font", "12px sans-serif")
        .style("background", "lightsteelblue")
        .style("border", "0px")
        .style("border-radius", "8px")
        .style("pointer-events", "none")
        .style("opacity", 0);

    const slices = svg.selectAll(".arc")
        .data(pie(data))
        .enter().append("g")
        .attr("class", "arc")
        .append("path")
        .attr("d", arc)
        .attr("fill", (d, i) => `url(#pie-gradient${i})`)
        .attr("stroke", "white")
        .attr("stroke-width", "1px")
        .on("mouseover", function(event, d) {
            d3.select(this).transition()
                .duration(200)
                .attr("transform", "scale(1.02)"); // Zoom effect

            tooltip.transition()
                .duration(200)
                .style("opacity", .9);
            tooltip.html(`Category: ${d.data.category}<br/>Value: ${d.data.value}`)
                .style("left", (event.pageX + 30) + "px")
                .style("top", (event.pageY - 20) + "px");
        })
        .on("mouseout", function() {
            d3.select(this).transition()
                .duration(500)
                .attr("transform", "scale(1)");

            tooltip.transition()
                .duration(500)
                .style("opacity", 0);
        });

    // Adding text inside pie slices
    slices.append("text")
        .attr("transform", d => `translate(${arc.centroid(d)})`)
        .attr("dy", ".35em")
        .attr("text-anchor", "middle")
        .style("font-size", "18px")  // Increased font size
        .style("font-weight", "bold")
        .text(d => `${Math.round(d.data.value / total * 100)}%`);  // Display percentage

    // Add legend
    const legend = d3.select("#pie-chart").append("div")
        .attr("class", "legend")
        .style("position", "absolute")
        .style("left", `${width + 20}px`)  // Positioning legend beside the pie chart
        .style("top", "50%")
        .style("transform", "translateY(-50%)");

    data.forEach((d, i) => {
        const legendItem = legend.append("div")
            .style("display", "flex")
            .style("align-items", "center")
            .style("margin", "2px");

        legendItem.append("div")
            .style("width", "20px")
            .style("height", "20px")
            .style("background-color", d3.interpolateCool(i / data.length))
            .style("margin-right", "5px");

        legendItem.append("span").text(d.category);
    });
}


