import jsPDF from "jspdf";
import html2canvas from "html2canvas";

// Export the order summary section as PDF and return the blob
export async function exportOrderSummaryToPDF(): Promise<Blob | undefined> {
  const input = document.getElementById("order-summary-preview");
  if (!input) {
    alert("Order summary not found!");
    return;
  }
  input.scrollIntoView();
  await new Promise((r) => setTimeout(r, 100));
  const canvas = await html2canvas(input);
  const imgData = canvas.toDataURL("image/png");

  const pdf = new jsPDF({
    orientation: "portrait",
    unit: "mm",
    format: "a4",
  });

  const imgWidth = 190;
  const ratio = imgWidth / canvas.width;
  const imgHeight = canvas.height * ratio;
  pdf.addImage(imgData, "PNG", 10, 10, imgWidth, imgHeight);

  // For downloading:
  // pdf.save("Estre-Order-Summary.pdf");

  return pdf.output("blob");
}

